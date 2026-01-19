# frozen_string_literal: true

module SalesTax
  module Receipt
    # Holds all line items and calculates totals.
    class Receipt
      attr_reader :line_items

      def initialize(line_items:)
        @line_items = line_items.freeze
        freeze
      end

      def total_tax
        line_items.sum(&:tax_amount)
      end

      def total
        line_items.sum(&:total_price)
      end
    end
  end
end
