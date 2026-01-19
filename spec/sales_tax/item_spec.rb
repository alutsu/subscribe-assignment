# frozen_string_literal: true

RSpec.describe SalesTax::Item do
  subject(:item) { described_class.new(quantity: 1, name: 'book', unit_price: 12.49) }

  describe '#imported?' do
    it 'returns true for imported items' do
      imported_item = described_class.new(quantity: 1, name: 'imported bottle of perfume', unit_price: 47.50)
      expect(imported_item).to be_imported
    end

    it 'returns true when imported appears at the start' do
      imported_item = described_class.new(quantity: 1, name: 'imported box of chocolates', unit_price: 10.00)
      expect(imported_item).to be_imported
    end

    it 'returns false for non-imported items' do
      regular_item = described_class.new(quantity: 1, name: 'bottle of perfume', unit_price: 18.99)
      expect(regular_item).not_to be_imported
    end
  end

  describe '#exempt?' do
    context 'with books' do
      it 'returns true for items containing "book"' do
        book = described_class.new(quantity: 2, name: 'book', unit_price: 12.49)
        expect(book).to be_exempt
      end
    end

    context 'with food' do
      it 'returns true for chocolate items' do
        chocolate = described_class.new(quantity: 1, name: 'chocolate bar', unit_price: 0.85)
        expect(chocolate).to be_exempt
      end

      it 'returns true for imported chocolates' do
        imported_chocolate = described_class.new(quantity: 1, name: 'imported box of chocolates', unit_price: 10.00)
        expect(imported_chocolate).to be_exempt
      end
    end

    context 'with medical products' do
      it 'returns true for headache pills' do
        pills = described_class.new(quantity: 1, name: 'packet of headache pills', unit_price: 9.75)
        expect(pills).to be_exempt
      end
    end

    context 'with non-exempt items' do
      it 'returns false for music CD' do
        cd = described_class.new(quantity: 1, name: 'music CD', unit_price: 14.99)
        expect(cd).not_to be_exempt
      end

      it 'returns false for perfume' do
        perfume = described_class.new(quantity: 1, name: 'bottle of perfume', unit_price: 18.99)
        expect(perfume).not_to be_exempt
      end
    end
  end

  describe '#subtotal' do
    it 'calculates quantity times unit price' do
      multi_item = described_class.new(quantity: 2, name: 'book', unit_price: 12.49)
      expect(multi_item.subtotal).to eq(24.98)
    end

    it 'returns unit price for quantity of 1' do
      single_item = described_class.new(quantity: 1, name: 'music CD', unit_price: 14.99)
      expect(single_item.subtotal).to eq(14.99)
    end

    it 'handles multiple quantities correctly' do
      multi_item = described_class.new(quantity: 3, name: 'imported boxes of chocolates', unit_price: 11.25)
      expect(multi_item.subtotal).to eq(33.75)
    end
  end

  describe 'immutability' do
    it_behaves_like 'an immutable object'
    it_behaves_like 'has frozen string attribute', :name
  end
end
