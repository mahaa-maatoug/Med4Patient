import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { PrescriptionStatus } from '../../../core/enums/PrescriptionStatus';

export type OrdonnanceDocument = Ordonnance & Document;

@Schema({ timestamps: true })
export class Ordonnance {
  @Prop({  unique: true })    id: string;
  @Prop({ required: true })
  patientId: string;

  @Prop({ required: true })
  pharmacyId: string;
  @Prop({ type: [String], required: true }) // Stocker les URLs des fichiers
  storagePath: string[];


  @Prop()
  fileSize: number;

  @Prop()
  issueDate: Date;

  @Prop({ required: true })
  prescriptionStatus: PrescriptionStatus;

  @Prop({ default: false })
  approved: boolean;

  @Prop()
  note?: string;

  @Prop({  type: Date })
  uploadedAt: Date;

  @Prop({ type: Date })
  reviewedAt?: Date;

  @Prop()
  reviewedBy?: string;

  @Prop()
  rejectionReason?: string;

  @Prop({ type: Date })
  expiresAt?: Date;
}

export const OrdonnanceSchema = SchemaFactory.createForClass(Ordonnance);
