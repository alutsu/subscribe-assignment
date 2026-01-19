# frozen_string_literal: true

RSpec.describe SalesTax::Rules::BasicTaxRule do
  subject(:rule) { described_class.new }

  describe '#rate' do
    it 'returns 0.10' do
      expect(rule.rate).to eq(0.10)
    end
  end

  describe '#applicable?' do
    it 'returns true for non-exempt items' do
      item = SalesTax::Item.new(quantity: 1, name: 'music CD', unit_price: 14.99)
      expect(rule.applicable?(item)).to be true
    end

    it 'returns false for books' do
      item = SalesTax::Item.new(quantity: 1, name: 'book', unit_price: 12.49)
      expect(rule.applicable?(item)).to be false
    end

    it 'returns false for food' do
      item = SalesTax::Item.new(quantity: 1, name: 'chocolate bar', unit_price: 0.85)
      expect(rule.applicable?(item)).to be false
    end

    it 'returns false for medical products' do
      item = SalesTax::Item.new(quantity: 1, name: 'headache pills', unit_price: 9.75)
      expect(rule.applicable?(item)).to be false
    end
  end
end
