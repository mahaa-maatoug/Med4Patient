
import { Body, Controller, Get, Param, Post, Put } from '@nestjs/common';
import { OrderService } from './order.service';

@Controller('orders')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  async create(@Body() data: any) {
    return this.orderService.createOrder(data);
  }

  @Get('patient/:patientId')
  async getByPatient(@Param('patientId') patientId: string) {
    return this.orderService.getPatientOrders(patientId);
  }

  @Put(':id/status')
  async updateStatus(
    @Param('id') id: string,
    @Body('status') status: string,
  ) {
    return this.orderService.updateOrderStatus(id, status);
  }
}