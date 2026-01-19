# frozen_string_literal: true

RSpec.describe 'Sales Tax Integration' do
  subject(:basket) { SalesTax::ShoppingBasket.new }

  describe 'Input 1: Basic items with no imports' do
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

    it 'produces the correct receipt' do
      expect(basket.process(input)).to eq(expected_output)
    end

    it 'calculates correct tax amount' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total_tax).to eq(1.50)
    end

    it 'calculates correct total' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total).to eq(42.32)
    end
  end

  describe 'Input 2: Imported items only' do
    let(:input) do
      <<~INPUT
        1 imported box of chocolates at 10.00
        1 imported bottle of perfume at 47.50
      INPUT
    end

    let(:expected_output) do
      <<~OUTPUT.chomp
        1 imported box of chocolates: 10.50
        1 imported bottle of perfume: 54.65
        Sales Taxes: 7.65
        Total: 65.15
      OUTPUT
    end

    it 'produces the correct receipt' do
      expect(basket.process(input)).to eq(expected_output)
    end

    it 'calculates correct tax amount' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total_tax).to eq(7.65)
    end

    it 'calculates correct total' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total).to eq(65.15)
    end
  end

  describe 'Input 3: Mixed items with quantities' do
    let(:input) do
      <<~INPUT
        1 imported bottle of perfume at 27.99
        1 bottle of perfume at 18.99
        1 packet of headache pills at 9.75
        3 imported boxes of chocolates at 11.25
      INPUT
    end

    let(:expected_output) do
      <<~OUTPUT.chomp
        1 imported bottle of perfume: 32.19
        1 bottle of perfume: 20.89
        1 packet of headache pills: 9.75
        3 imported boxes of chocolates: 35.55
        Sales Taxes: 7.90
        Total: 98.38
      OUTPUT
    end

    it 'produces the correct receipt' do
      expect(basket.process(input)).to eq(expected_output)
    end

    it 'calculates correct tax amount' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total_tax).to eq(7.90)
    end

    it 'calculates correct total' do
      receipt = basket.generate_receipt(input)
      expect(receipt.total).to eq(98.38)
    end
  end

  describe 'tax rule verification' do
    context 'when item is exempt and not imported' do
      it 'applies no tax to books' do
        receipt = basket.generate_receipt('1 book at 10.00')
        expect(receipt.total_tax).to eq(0.00)
        expect(receipt.total).to eq(10.00)
      end

      it 'applies no tax to food' do
        receipt = basket.generate_receipt('1 chocolate bar at 10.00')
        expect(receipt.total_tax).to eq(0.00)
        expect(receipt.total).to eq(10.00)
      end

      it 'applies no tax to medical products' do
        receipt = basket.generate_receipt('1 headache pills at 10.00')
        expect(receipt.total_tax).to eq(0.00)
        expect(receipt.total).to eq(10.00)
      end
    end

    context 'when item is not exempt and not imported' do
      it 'applies 10% basic tax' do
        receipt = basket.generate_receipt('1 music CD at 10.00')
        expect(receipt.total_tax).to eq(1.00)
        expect(receipt.total).to eq(11.00)
      end
    end

    context 'when item is exempt and imported' do
      it 'applies only 5% import duty' do
        receipt = basket.generate_receipt('1 imported chocolate at 10.00')
        expect(receipt.total_tax).to eq(0.50)
        expect(receipt.total).to eq(10.50)
      end
    end

    context 'when item is not exempt and imported' do
      it 'applies both 10% basic tax and 5% import duty' do
        receipt = basket.generate_receipt('1 imported perfume at 10.00')
        expect(receipt.total_tax).to eq(1.50)
        expect(receipt.total).to eq(11.50)
      end
    end
  end

  describe 'rounding behavior' do
    it 'rounds up tax to nearest 0.05' do
      # 14.99 * 0.10 = 1.499 should round up to 1.50
      receipt = basket.generate_receipt('1 music CD at 14.99')
      expect(receipt.total_tax).to eq(1.50)
    end

    it 'handles exact 0.05 multiples correctly' do
      receipt = basket.generate_receipt('1 perfume at 10.00')
      expect(receipt.total_tax).to eq(1.00)
    end
  end
end
