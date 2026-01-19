# frozen_string_literal: true

module SalesTax
  # Main entry point. Parses input, calculates taxes, and prints receipt.
  class ShoppingBasket
    attr_reader :parser, :calculator, :printer

    def initialize(parser: nil, calculator: nil, printer: nil)
      @parser = parser || InputParser.new
      @calculator = calculator || TaxCalculator.new
      @printer = printer || Receipt::Printer.new
    end

    def process(input)
      items = parser.parse(input)
      receipt = build_receipt(items)
      printer.print(receipt)
    end

    def generate_receipt(input)
      items = parser.parse(input)
      build_receipt(items)
    end

    private

    def build_receipt(items)
      line_items = items.map { |item| build_line_item(item) }
      Receipt::Receipt.new(line_items: line_items)
    end

    def build_line_item(item)
      tax_amount = calculator.calculate_tax(item)
      total_price = item.subtotal + tax_amount

      Receipt::LineItem.new(
        quantity: item.quantity,
        name: item.name,
        total_price: total_price,
        tax_amount: tax_amount
      )
    end
  end
end
