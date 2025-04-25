import { Injectable } from '@nestjs/common';

import { ProductRepository } from './products.repository';


@Injectable()
export class ProductService {
  constructor(private readonly productRepository: ProductRepository) {}

  create(data: any) {
    return this.productRepository.create(data);
  }

  findAll() {
    return this.productRepository.findAll();
  }

  findById(id: string) {
    return this.productRepository.findById(id);
  }

  update(id: string, data: any) {
    return this.productRepository.update(id, data);
  }

  delete(id: string) {
    return this.productRepository.delete(id);
  }

  findByCategory(category: string) {
    return this.productRepository.findByCategory(category);
  }

  async addImages(id: string, imagePaths: string[]) {
    const product = await this.productRepository.findById(id);
    if (!product) throw new Error('Produit introuvable');
    const updatedPaths = [...(product.storagePath || []), ...imagePaths];
    return this.productRepository.update(id, { storagePath: updatedPaths });
  }
}