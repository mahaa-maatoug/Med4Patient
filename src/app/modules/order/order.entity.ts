
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Product } from '../product/product.entity';


export type OrderDocument = Order & Document;

@Schema({ timestamps: true })
export class Order {
  @Prop({ required: true })
  patientId: string;

  @Prop()
  pharmacyId: string;

  @Prop({ type: Array, required: true })
  items: {
    product: Product;
    quantity: number;
    priceAtPurchase: number;
  }[];

  @Prop({ required: true })
  totalAmount: number;

  @Prop({ default: 'pending' })
  status: 'pending' | 'processing' | 'completed' | 'cancelled';

  @Prop()
  paymentMethod: string;

  @Prop()
  deliveryAddress: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);