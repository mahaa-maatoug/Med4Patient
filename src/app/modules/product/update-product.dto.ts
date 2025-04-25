import { CreateProductDto } from './createproductDto';
import { PartialType } from '@nestjs/mapped-types';

export class UpdateProductDto extends PartialType(CreateProductDto) {}