import { Module } from '@nestjs/common';
import { PropertyModule } from './modules/property/property.module';

@Module({
  imports: [PropertyModule],
})
export class AppModule {}
