import { UploadedFiles} from '@nestjs/common';
import { diskStorage } from 'multer';
import {
  Controller,
  Post,
  Get,
  Put,
  Delete,
  Param,
  Body,

  UseInterceptors,
} from '@nestjs/common';

import { FileFieldsInterceptor } from '@nestjs/platform-express';

import { extname } from 'path';
import { ProductService } from './product.service';
import { CreateProductDto } from './createproductDto';
@Controller('products')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Post()
  @UseInterceptors(
    FileFieldsInterceptor([{ name: 'images', maxCount: 5 }], {
      storage: diskStorage({
        destination: './uploads/products',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          callback(null, uniqueSuffix + extname(file.originalname));
        },
      }),
    }),
  )
  async createWithImages(
    @UploadedFiles() files: { images?: Express.Multer.File[] },
    @Body() body: CreateProductDto,
  ) {
    const imagePaths = files.images?.map((file) => file.path) || [];
    return this.productService.create({ ...body, storagePath: imagePaths });
  }
  @Get()
  findAll() {
    return this.productService.findAll();
  }

  @Get(':id')
  findById(@Param('id') id: string) {
    return this.productService.findById(id);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.productService.update(id, data);
  }

  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.productService.delete(id);
  }

  @Get('/category/:category')
  findByCategory(@Param('category') category: string) {
    return this.productService.findByCategory(category);
  }

  @Put(':id/upload')
  @UseInterceptors(
    FileFieldsInterceptor([{ name: 'images', maxCount: 5 }], {
      storage: diskStorage({
        destination: './uploads/products',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          callback(null, uniqueSuffix + extname(file.originalname));
        },
      }),
    }),
  )
  uploadImages(@Param('id') id: string, @UploadedFiles() files: { images?: Express.Multer.File[] }) {
    const paths = files.images?.map((file) => file.path) || [];
    return this.productService.addImages(id, paths);
  }
}