import { Injectable, NotFoundException } from '@nestjs/common';
import { OrdonnanceRepository } from './ordonnance.repository';
import { CreateOrdonnanceDto, UpdateOrdonnanceDto } from './ordonnance.dto';


@Injectable()
export class OrdonnanceService {
  constructor(private readonly ordonnanceRepository: OrdonnanceRepository) {}

  async create(createOrdonnanceDto: CreateOrdonnanceDto, storagePath: string[]) {
    return this.ordonnanceRepository.create({ ...createOrdonnanceDto, storagePath });
  }

  async findAll() {
    return this.ordonnanceRepository.findAll();
  }

  async findOne(id: string) {
    const ordonnance = await this.ordonnanceRepository.findById(id);
    if (!ordonnance) {
      throw new NotFoundException('Ordonnance non trouvée');
    }
    return ordonnance;
  }

  async update(id: string, updateOrdonnanceDto: UpdateOrdonnanceDto) {
    return this.ordonnanceRepository.update(id, updateOrdonnanceDto);
  }

  async delete(id: string) {
    return this.ordonnanceRepository.delete(id);
  }
}
