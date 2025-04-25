
import { Injectable } from '@nestjs/common';
import { OrderRepository } from './order.repository';
import { ProductService } from '../product/product.service';


@Injectable()
export class OrderService {
  constructor(
    private readonly orderRepository: OrderRepository,
    private readonly productService: ProductService,
  ) {}

  async createOrder(data: {
    patientId: string;
    pharmacyId: string;
    items: Array<{
      productId: string;
      quantity: number;
    }>;
    paymentMethod: string;
    deliveryAddress: string;
  }) {
    // Fetch products to get current prices
    const products = await Promise.all(
      data.items.map(item =>
        this.productService.findById(item.productId)
      )
    );

    // Prepare order items
    const orderItems = products.map((product, index) => ({
      product: product,
      quantity: data.items[index].quantity,
      priceAtPurchase: product.price,
    }));

    // Calculate total
    const totalAmount = orderItems.reduce(
      (sum, item) => sum + (item.priceAtPurchase * item.quantity),
      0
    );

    // Create order
    return this.orderRepository.create({
      patientId: data.patientId,
      pharmacyId: data.pharmacyId,
      items: orderItems,
      totalAmount,
      status: 'pending',
      paymentMethod: data.paymentMethod,
      deliveryAddress: data.deliveryAddress,
    });
  }

  async getPatientOrders(patientId: string) {
    return this.orderRepository.findByPatientId(patientId);
  }

  async updateOrderStatus(id: string, status: string) {
    return this.orderRepository.updateStatus(id, status);
  }
}