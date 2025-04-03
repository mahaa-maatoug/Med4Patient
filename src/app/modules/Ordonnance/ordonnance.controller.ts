import { Controller, Get, Post, Put, Delete, Param, Body, UseInterceptors, UploadedFiles } from '@nestjs/common';
import {  FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { OrdonnanceService } from './ordonnance.service';
import { CreateOrdonnanceDto, UpdateOrdonnanceDto } from './ordonnance.dto';
import { v4 as uuidv4 } from 'uuid';
import { extname } from 'path';

@Controller('ordonnances')
export class OrdonnanceController {
  constructor(private readonly ordonnanceService: OrdonnanceService) {}

  @Post()
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

  @Get()
  async findAll() {
    return this.ordonnanceService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.ordonnanceService.findOne(id);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateOrdonnanceDto: UpdateOrdonnanceDto) {
    return this.ordonnanceService.update(id, updateOrdonnanceDto);
  }

  @Delete(':id')
  async delete(@Param('id') id: string) {
    await this.ordonnanceService.delete(id);
    return { message: 'Ordonnance supprimée avec succès' };
  }
}
