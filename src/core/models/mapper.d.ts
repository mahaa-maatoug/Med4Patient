export interface Mapper<To, From> {
    toJson?(raw: To): From;
    fromJson?(raw: From): To;
}
