import { StandardFrequencyType } from '../enums/StandardFrequencyType';
import { PeriodType } from '../enums/PeriodType';
export interface FrequencyOptions {
    standardFrequency?: StandardFrequencyType;
    each?: number;
    period?: PeriodType;
}
