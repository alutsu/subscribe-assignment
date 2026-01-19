# frozen_string_literal: true

RSpec.describe SalesTax::TaxCalculator do
  subject(:calculator) { described_class.new }

  describe '#calculate_tax' do
    context 'with exempt items (no import)' do
      it 'returns 0 for a book' do
        item = SalesTax::Item.new(quantity: 1, name: 'book', unit_price: 12.49)
        expect(calculator.calculate_tax(item)).to eq(0.0)
      end

      it 'returns 0 for chocolate' do
        item = SalesTax::Item.new(quantity: 1, name: 'chocolate bar', unit_price: 0.85)
        expect(calculator.calculate_tax(item)).to eq(0.0)
      end

      it 'returns 0 for medical products' do
        item = SalesTax::Item.new(quantity: 1, name: 'packet of headache pills', unit_price: 9.75)
        expect(calculator.calculate_tax(item)).to eq(0.0)
      end
    end

    context 'with non-exempt items (no import)' do
      it 'applies 10% basic tax to music CD' do
        item = SalesTax::Item.new(quantity: 1, name: 'music CD', unit_price: 14.99)
        
        expect(calculator.calculate_tax(item)).to eq(1.50)
      end

      it 'applies 10% basic tax to perfume' do
        item = SalesTax::Item.new(quantity: 1, name: 'bottle of perfume', unit_price: 18.99)
        
        expect(calculator.calculate_tax(item)).to eq(1.90)
      end
    end

    context 'with imported exempt items' do
      it 'applies only 5% import duty to imported chocolates' do
        item = SalesTax::Item.new(quantity: 1, name: 'imported box of chocolates', unit_price: 10.00)
        
        expect(calculator.calculate_tax(item)).to eq(0.50)
      end
    end

    context 'with imported non-exempt items' do
      it 'applies both 10% basic and 5% import to imported perfume' do
        item = SalesTax::Item.new(quantity: 1, name: 'imported bottle of perfume', unit_price: 47.50)
        
        expect(calculator.calculate_tax(item)).to eq(7.15)
      end

      it 'applies both taxes correctly for another imported perfume' do
        item = SalesTax::Item.new(quantity: 1, name: 'imported bottle of perfume', unit_price: 27.99)
        
        expect(calculator.calculate_tax(item)).to eq(4.20)
      end
    end

    context 'with multiple quantities' do
      it 'calculates tax on the subtotal' do
        item = SalesTax::Item.new(quantity: 2, name: 'book', unit_price: 12.49)
        expect(calculator.calculate_tax(item)).to eq(0.0)
      end

      it 'handles multiple imported chocolates' do
        item = SalesTax::Item.new(quantity: 3, name: 'imported boxes of chocolates', unit_price: 11.25)
        
        expect(calculator.calculate_tax(item)).to eq(1.80)
      end
    end
  end

  describe 'rounding' do
    it 'rounds up to nearest 0.05' do
      item = SalesTax::Item.new(quantity: 1, name: 'widget', unit_price: 10.01)
      
      expect(calculator.calculate_tax(item)).to eq(1.05)
    end

    it 'keeps exact 0.05 multiples as is' do
      item = SalesTax::Item.new(quantity: 1, name: 'widget', unit_price: 10.00)
      
      expect(calculator.calculate_tax(item)).to eq(1.00)
    end
  end
end
