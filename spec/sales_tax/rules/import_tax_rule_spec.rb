# frozen_string_literal: true

RSpec.describe SalesTax::Rules::ImportTaxRule do
  subject(:rule) { described_class.new }

  describe '#rate' do
    it 'returns 0.05' do
      expect(rule.rate).to eq(0.05)
    end
  end

  describe '#applicable?' do
    it 'returns true for imported items' do
      item = SalesTax::Item.new(quantity: 1, name: 'imported perfume', unit_price: 47.50)
      expect(rule.applicable?(item)).to be true
    end

    it 'returns false for non-imported items' do
      item = SalesTax::Item.new(quantity: 1, name: 'perfume', unit_price: 18.99)
      expect(rule.applicable?(item)).to be false
    end

    it 'returns true for imported exempt items' do
      item = SalesTax::Item.new(quantity: 1, name: 'imported chocolate', unit_price: 10.00)
      expect(rule.applicable?(item)).to be true
    end
  end
end
