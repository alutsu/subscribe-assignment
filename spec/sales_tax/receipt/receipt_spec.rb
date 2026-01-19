# frozen_string_literal: true

RSpec.describe SalesTax::Receipt::Receipt do
  subject(:receipt) { described_class.new(line_items: line_items) }

  let(:line_items) do
    [
      SalesTax::Receipt::LineItem.new(quantity: 1, name: 'item1', total_price: 11.00, tax_amount: 1.00),
      SalesTax::Receipt::LineItem.new(quantity: 1, name: 'item2', total_price: 22.00, tax_amount: 2.00)
    ]
  end

  describe '#total_tax' do
    it 'sums tax amounts from all line items' do
      expect(receipt.total_tax).to eq(3.00)
    end

    context 'when no taxes applied' do
      let(:line_items) do
        [SalesTax::Receipt::LineItem.new(quantity: 1, name: 'book', total_price: 12.49, tax_amount: 0.00)]
      end

      it 'returns 0' do
        expect(receipt.total_tax).to eq(0.00)
      end
    end
  end

  describe '#total' do
    it 'sums total prices from all line items' do
      expect(receipt.total).to eq(33.00)
    end
  end
end
