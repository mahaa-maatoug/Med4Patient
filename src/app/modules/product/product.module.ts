import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Product, ProductSchema } from './product.entity';
import { MulterModule } from '@nestjs/platform-express';
import { ProductController } from './product.controller';
import { ProductService } from './product.service';
import { ProductRepository } from './products.repository';


@Module({
  imports: [
    MongooseModule.forFeature([{ name: Product.name, schema: ProductSchema }]),
    MulterModule.register({
      dest: './uploads/products',
    }),
  ],
  controllers: [ProductController],
  providers: [ProductService, ProductRepository],
  exports: [ProductService],
})
export class ProductModule {}