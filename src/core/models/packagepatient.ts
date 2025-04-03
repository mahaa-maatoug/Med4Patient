import { Prop } from '@nestjs/mongoose';
import { AuthorizedPerson } from './AuthorizedPerson';

export class PackagePatient {
  @Prop({ required: true })
  id: string;

  @Prop({ required: true })
  fullName: string;

  @Prop({ required: true })
  roomNumber: number;

  @Prop({ required: true })
  paymentType: string;

  @Prop({ required: true })
  signatureType: string;

  @Prop({ type: [String] })
  deliveryType: string[];

  @Prop()
  pharmacyNote: string;

  @Prop()
  deliveryManNote: string;

  @Prop()
  householdNote: string;

  @Prop({ type: Object })
  authorizedPerson: AuthorizedPerson;

  @Prop()
  spot: string;

  @Prop()
  recipient: string | null;

  @Prop()
  price: number | null;

  @Prop()
  packagePrice?: number;

  @Prop()
  additionalPrice?: number;

  @Prop()
  hospitalizedPatient?: boolean;

  @Prop()
  completed?: boolean;

  @Prop()
  delivered?: boolean;

  @Prop()
  isPrepared?: boolean;
}