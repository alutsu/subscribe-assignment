# frozen_string_literal: true

RSpec.describe SalesTax::Receipt::LineItem do
  subject(:line_item) do
    described_class.new(
      quantity: 2,
      name: 'book',
      total_price: 24.98,
      tax_amount: 0.00
    )
  end

  describe 'attributes' do
    it 'stores quantity' do
      expect(line_item.quantity).to eq(2)
    end

    it 'stores name' do
      expect(line_item.name).to eq('book')
    end

    it 'stores total_price' do
      expect(line_item.total_price).to eq(24.98)
    end

    it 'stores tax_amount' do
      expect(line_item.tax_amount).to eq(0.00)
    end
  end
end
