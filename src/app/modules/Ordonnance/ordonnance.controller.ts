import { Controller, Get, Post, Put, Delete, Param, Body, UseInterceptors, UploadedFiles, Res } from '@nestjs/common';
import {  FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { OrdonnanceService } from './ordonnance.service';
import { CreateOrdonnanceDto, UpdateOrdonnanceDto } from './ordonnance.dto';
import { v4 as uuidv4 } from 'uuid';
import { extname } from 'path';
import { Response } from 'express';
import * as fs from 'fs';
import * as path from 'path';
@Controller('prescription')
export class OrdonnanceController {
  constructor(private readonly ordonnanceService: OrdonnanceService) {}

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

  @Delete('/delete:id')
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
}
