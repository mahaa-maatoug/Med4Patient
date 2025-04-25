import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseInterceptors,
  UploadedFiles,
  Res,
  BadRequestException, Query,
} from '@nestjs/common';
import {  FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { OrdonnanceService } from './ordonnance.service';
import { CreateOrdonnanceDto, UpdateOrdonnanceDto } from './ordonnance.dto';
import { v4 as uuidv4 } from 'uuid';
import { extname } from 'path';
import { Response } from 'express';
import * as fs from 'fs';
import * as path from 'path';
import { OcrService } from './ocr.service';
@Controller('prescription')
export class OrdonnanceController {
  constructor(private readonly ordonnanceService: OrdonnanceService , private readonly ocrService: OcrService) {}

  @Post('/add')
  @UseInterceptors(
    FilesInterceptor('storagePath', 5, {
      storage: diskStorage({
        destination: './uploads/ordonnances',
        filename: (req, file, callback) => {
          const uniqueFilename = `${uuidv4()}${extname(file.originalname)}`;
          callback(null, uniqueFilename);
        },
      }),
    }),
  )
  async create(@Body() createOrdonnanceDto: CreateOrdonnanceDto, @UploadedFiles() storagePath: Express.Multer.File[]) {
    const fileUrls = storagePath.map(file => `/uploads/ordonnances/${file.filename}`);
    return this.ordonnanceService.create(createOrdonnanceDto, fileUrls);
  }

  @Get('/getAll')
  async findAll() {
    return this.ordonnanceService.findAll();
  }

  @Get('/getById/:id')
  async findOne(@Param('id') id: string) {
    return this.ordonnanceService.findOne(id);
  }

  @Put('/update/:id')
  async update(@Param('id') id: string, @Body() updateOrdonnanceDto: UpdateOrdonnanceDto) {
    return this.ordonnanceService.update(id, updateOrdonnanceDto);
  }

  @Delete('/delete/:id')
  async delete(@Param('id') id: string) {
    await this.ordonnanceService.delete(id);
    return { message: 'Ordonnance supprimée avec succès' };
  }
  @Get('download/:filename')
  async downloadFile(
    @Param('filename') filename: string,
    @Res() res: Response
  ) {
    try {
      const filePath = path.join(__dirname, '..', 'uploads', 'ordonnances', filename);

      // Vérifier que le fichier existe
      if (!fs.existsSync(filePath)) {
        throw new Error('File not found');
      }

      // Déterminer le type MIME
      const mimeType = {
        '.pdf': 'application/pdf',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.png': 'image/png',
        '.doc': 'application/msword',
        '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      }[path.extname(filename).toLowerCase()] || 'application/octet-stream';

      // Configurer les headers de réponse
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      res.setHeader('Content-Type', mimeType);

      // Créer un stream de lecture et l'envoyer
      const fileStream = fs.createReadStream(filePath);
      fileStream.pipe(res);
    } catch  {
      res.status(404).send('File not found');
    }
  }
  @Get('/history')
  async getHistory(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string
  ) {
    // Validate and parse dates
    const start = new Date(startDate);
    const end = new Date(endDate);

    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      throw new BadRequestException('Invalid date format');
    }

    // Add one day to end date to include the entire end day
    end.setDate(end.getDate() + 1);

    return this.ordonnanceService.findByDateRange(start, end);
  }
  @Post('/process-prescription')
  @UseInterceptors(
    FilesInterceptor('storagePath', 5, {
      storage: diskStorage({
        destination: './uploads/ordonnances',
        filename: (req, file, callback) => {
          const uniqueFilename = `${uuidv4()}${extname(file.originalname)}`;
          callback(null, uniqueFilename);
        },
      }),
      fileFilter: (req, file, callback) => {
        // Validate file types
        const allowedTypes = [
          'image/jpeg',
          'image/png',
          'application/pdf',
          'image/tiff'
        ];
        if (allowedTypes.includes(file.mimetype)) {
          callback(null, true);
        } else {
          callback(
            new BadRequestException(
              'Only JPEG, PNG, PDF, and TIFF files are allowed'
            ),
            false
          );
        }
      },
      limits: {
        fileSize: 5 * 1024 * 1024, // 5MB limit
      },
    })
  )
  async processPrescription(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() createOrdonnanceDto: CreateOrdonnanceDto
  ) {
    if (!files || files.length === 0) {
      throw new BadRequestException('At least one file is required');
    }

    try {
      // Process each file with OCR
      const ocrResults = await Promise.all(
        files.map(file => this.ocrService.recognizeMedicationNames(file.path))
      );

      const recognizedMeds = ocrResults.flat();
      const fileUrls = files.map(file => `/uploads/ordonnances/${file.filename}`);

      // Create prescription with recognized medications
      return await this.ordonnanceService.create(
        {
          ...createOrdonnanceDto,
          medications: recognizedMeds // Include recognized medications
        },
        fileUrls
      );
    } catch (error) {
      // Clean up uploaded files if processing fails
      files.forEach(file => {
        try {
          fs.unlinkSync(file.path);
        } catch (err) {
          console.error('Failed to clean up file:', file.path, err);
        }
      });
      throw new BadRequestException(
        `Failed to process prescription: ${error.message}`
      );
    }
  }
}
