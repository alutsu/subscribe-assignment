# frozen_string_literal: true

RSpec.describe SalesTax::InputParser do
  subject(:parser) { described_class.new }

  describe '#parse_line' do
    it 'parses a simple item' do
      item = parser.parse_line('1 music CD at 14.99')

      expect(item.quantity).to eq(1)
      expect(item.name).to eq('music CD')
      expect(item.unit_price).to eq(14.99)
    end

    it 'parses an item with quantity > 1' do
      item = parser.parse_line('2 book at 12.49')

      expect(item.quantity).to eq(2)
      expect(item.name).to eq('book')
      expect(item.unit_price).to eq(12.49)
    end

    it 'parses an imported item' do
      item = parser.parse_line('1 imported bottle of perfume at 47.50')

      expect(item.quantity).to eq(1)
      expect(item.name).to eq('imported bottle of perfume')
      expect(item.unit_price).to eq(47.50)
      expect(item).to be_imported
    end

    it 'parses an item with "box of" in the name' do
      item = parser.parse_line('1 imported box of chocolates at 10.00')

      expect(item.name).to eq('imported box of chocolates')
      expect(item).to be_exempt
    end

    context 'with invalid input' do
      it 'raises ArgumentError for malformed line' do
        expect { parser.parse_line('invalid line') }
          .to raise_error(ArgumentError, /Invalid input format/)
      end

      it 'raises ArgumentError for missing price' do
        expect { parser.parse_line('1 book at') }
          .to raise_error(ArgumentError, /Invalid input format/)
      end
    end
  end

  describe '#parse' do
    it 'parses multiple lines' do
      input = <<~INPUT
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      INPUT

      items = parser.parse(input)

      expect(items.length).to eq(3)
      expect(items[0].name).to eq('book')
      expect(items[1].name).to eq('music CD')
      expect(items[2].name).to eq('chocolate bar')
    end

    it 'ignores empty lines' do
      input = <<~INPUT
        1 book at 12.49

        1 music CD at 14.99
      INPUT

      items = parser.parse(input)
      expect(items.length).to eq(2)
    end

    it 'handles input with imported items' do
      input = <<~INPUT
        1 imported box of chocolates at 10.00
        1 imported bottle of perfume at 47.50
      INPUT

      items = parser.parse(input)

      expect(items.length).to eq(2)
      expect(items).to all(be_imported)
    end
  end
end
