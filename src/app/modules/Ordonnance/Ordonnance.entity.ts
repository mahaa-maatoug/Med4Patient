import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { PrescriptionStatus } from '../../../core/enums/PrescriptionStatus';
import { ObjectId } from 'mongodb';

export type OrdonnanceDocument = Ordonnance & Document;

@Schema({ timestamps: true })
export class Ordonnance {
  @Prop({ required: true, default: () => new ObjectId().toString() })
  id: string;
  @Prop({
    type: String,
    required: true,
    unique: true,
    default: () => new ObjectId().toString()
  })
  idordonnace: string;

  @Prop()
  patientId: string;

  @Prop()
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
  @Prop()createdAt?: Date;
  @Prop()updatedAt?: Date;
}

export const OrdonnanceSchema = SchemaFactory.createForClass(Ordonnance);
