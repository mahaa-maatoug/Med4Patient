
import { AuthorizedPerson } from '../../../core/models/AuthorizedPerson';
import { PatientPaymentType } from '../../../core/enums/PatientPaymentType';
import { SignatureType } from '../../../core/enums/SignatureType';
import { VacationPeriod } from '../../../core/models/VacationPeriod';
import { Address } from '../../../core/models/Address';
import { RecurrenceOption } from '../../../core/models/RecurrenceOption';

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';


@Schema({ timestamps: true })
export class Patient extends Document {
  @Prop({ required: true })
  email: string;

  @Prop({ required: true })
  firstName: string;

  @Prop({ required: true })
  lastName: string;

  @Prop({ required: true })
  phone: string;

  @Prop()
  post: number;

  @Prop()
  officePhone?: string;

  @Prop({ type: Object })
  authorizedPerson: AuthorizedPerson;

  @Prop({ type: String, enum: PatientPaymentType, required: true })
  paymentType: PatientPaymentType;

  @Prop()
  deliveryManNote?: string;

  @Prop()
  pharmacyNote?: string;

  @Prop()
  householdNote?: string;

  @Prop()
  spot?: string;

  @Prop({ type: String, enum: SignatureType })
  signatureType?: SignatureType;

  @Prop()
  hospitalizedPatient?: boolean;

  @Prop({ type: Object })
  vacationPeriod?: VacationPeriod;

  @Prop({ type: [{ type: Object }] })
  address: Address[];

  @Prop({ type: Object })
  recurrenceOption: RecurrenceOption;

  @Prop({ type: [String] })
  deliveryType: string[];

  @Prop()
  houseHoldId?: string;

  @Prop()
  roomNumber?: number;

  @Prop({ required: true })
  createdBy: string;

  @Prop()
  deletedAt?: Date;

  @Prop()
  deletedBy?: string;
}

export const PatientSchema = SchemaFactory.createForClass(Patient);
