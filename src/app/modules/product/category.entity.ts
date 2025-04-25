import { Prop } from '@nestjs/mongoose';

export class Category {
  @Prop({ required: true })
  idcategory: string;

  @Prop({ required: true })
  type: string;
}