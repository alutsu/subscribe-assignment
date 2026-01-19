# frozen_string_literal: true

RSpec.describe SalesTax::ShoppingBasket do
  subject(:basket) { described_class.new }

  describe '#process' do
    let(:input) do
      <<~INPUT
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      INPUT
    end

    let(:expected_output) do
      <<~OUTPUT.chomp
        2 book: 24.98
        1 music CD: 16.49
        1 chocolate bar: 0.85
        Sales Taxes: 1.50
        Total: 42.32
      OUTPUT
    end

    it 'returns formatted receipt string' do
      expect(basket.process(input)).to eq(expected_output)
    end
  end

  describe '#generate_receipt' do
    let(:input) { '1 book at 10.00' }

    it 'returns a Receipt object' do
      result = basket.generate_receipt(input)
      expect(result).to be_a(SalesTax::Receipt::Receipt)
    end

    it 'calculates correct totals' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total).to eq(10.00)
      expect(receipt.total_tax).to eq(0.00)
    end
  end

  describe 'dependency injection' do
    it 'accepts custom parser' do
      custom_parser = instance_double(SalesTax::InputParser)
      custom_basket = described_class.new(parser: custom_parser)
      expect(custom_basket.parser).to eq(custom_parser)
    end

    it 'accepts custom calculator' do
      custom_calculator = instance_double(SalesTax::TaxCalculator)
      custom_basket = described_class.new(calculator: custom_calculator)
      expect(custom_basket.calculator).to eq(custom_calculator)
    end

    it 'accepts custom printer' do
      custom_printer = instance_double(SalesTax::Receipt::Printer)
      custom_basket = described_class.new(printer: custom_printer)
      expect(custom_basket.printer).to eq(custom_printer)
    end
  end
end
