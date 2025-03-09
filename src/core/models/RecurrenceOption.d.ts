import { FrequencyOptions } from './FrequencyOptions';
export interface RecurrenceOption {
    note: string;
    frequency: string | FrequencyOptions;
    from: Date;
    to: Date;
}
