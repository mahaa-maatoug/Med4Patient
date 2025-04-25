import { StockStatus } from '../../../core/enums/stockstatus';


import { IsString, IsEnum, IsOptional, IsDateString, ValidateNested } from 'class-validator';
import { Category } from './category.entity';
import { Type } from 'class-transformer';
export class CreateProductDto {
  @IsString() name: string;

  @IsOptional() @IsString() description?: string;
  @IsOptional() quantity: number;
  @IsOptional() price: number;
  @IsOptional()  discount?: number;
  @IsOptional() storagePath?: string[]; // optional if no file uploaded yet
  @IsEnum(StockStatus) stockStatus: StockStatus;

  @IsOptional() @IsDateString() expiryDate?: Date;
  @IsOptional() @IsString() supplier?: string;
  @IsOptional() @IsString() barcode?: string;
  @IsOptional()  isTaxable?: boolean;
  @IsOptional()  showPrice?: boolean;
  @ValidateNested() // Valide que l'objet est conforme à la classe Category
  @Type(() => Category) // Nécessaire pour la transformation
  category: Category;
  @IsOptional() @IsString() brand?: string;}