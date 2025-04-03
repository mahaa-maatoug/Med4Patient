import { PreferenceType } from '../enums/preference';

export interface Preference{
  type: PreferenceType;
  time? : string;
  from?: string;
  to?: string;
}