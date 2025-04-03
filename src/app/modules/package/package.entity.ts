import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Address } from '../../../core/models/Address';
import { RecurrenceOption } from '../../../core/models/RecurrenceOption';
import { PackagePatient } from '../../../core/models/packagepatient';
import { PackagesStatus } from '../../../core/enums/packagestatus';
import { PackageReceiverType } from '../../../core/enums/package.eceivertype';
import { Preference } from '../../../core/models/preference';
import { Document } from 'mongoose';
@Schema({ timestamps: true })
export class Package extends Document {
  @Prop({ required: true })
  pharmacyId: string;

  @Prop({ required: true })
  priority: boolean;

  @Prop({ required: true })
  isPicking: boolean;

  @Prop({ enum: PackageReceiverType, required: true })
  receiverType: PackageReceiverType;

  @Prop()
  patientReceiver?: PackagePatient;

  @Prop()
  householdReceiver?: PackagePatient;

  @Prop({ type: Object, default: null })
  groupReceiver?: null;

  @Prop({ required: true })
  deliveryDate: string;

  @Prop({ required: true })
  deliveryTime: string;

  @Prop({ type: [{ type: Object }] })
  recurrenceOption?: RecurrenceOption;

  @Prop()
  recurrenceId?: string | null;

  @Prop()
  deliveryId?: string | null;

  @Prop({ enum: PackagesStatus, required: true })
  status: PackagesStatus;


  @Prop({ type: [{ type: Object }] })
  addresses?: Address[];

  @Prop({ type: [{ type: Object }] })
  originAddress?: Address[];

  @Prop({ type: Object , required: true })
  preference: Preference;

  @Prop()
  inRoute?: boolean;

  @Prop({ required: true })
  createdBy: string;

  @Prop()
  nbArticle?: number;

  @Prop()
  payedForDeliveryMan?: number;
}

export const PackageSchema = SchemaFactory.createForClass(Package);
export type PackageDocument = Package & Document & {
  toObject(options?: any): Package;
};