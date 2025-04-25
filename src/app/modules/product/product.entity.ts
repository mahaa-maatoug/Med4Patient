import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { StockStatus } from '../../../core/enums/stockstatus';


import {v4 as uuidv4} from "uuid";
import { Category } from './category.entity';
export type ProductDocument = Product & Document;

@Schema({ timestamps: true })
export class Product extends Document {
  @Prop({ required: true, unique: true, default: uuidv4 })    id: string;
  @Prop()    pharmacyId: string;
  @Prop()    name: string;
  @Prop()    description: string;
  @Prop()    quantity: number;
  @Prop()    price: number;
  @Prop({ default: 0 })    discount: number;
  @Prop({ type: [String] })    storagePath: string[];
  @Prop({ enum: StockStatus })    stockStatus: StockStatus;
  @Prop({ default: true })
  showPrice: boolean;
  @Prop()    expiryDate: Date;
  @Prop()    supplier: string;
  @Prop()    barcode: string;
  @Prop({ default: false })    isTaxable: boolean;
  @Prop({ type: Object }) // Changé pour accepter l'objet Category
  category: Category;
  @Prop()    brand: string;}
export const ProductSchema = SchemaFactory.createForClass(Product);