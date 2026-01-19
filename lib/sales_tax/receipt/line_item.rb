# frozen_string_literal: true

module SalesTax
  module Receipt
    # A single line on the receipt with calculated totals.
    class LineItem
      attr_reader :quantity, :name, :total_price, :tax_amount

      def initialize(quantity:, name:, total_price:, tax_amount:)
        @quantity = quantity
        @name = name.freeze
        @total_price = total_price
        @tax_amount = tax_amount
        freeze
      end
    end
  end
end
