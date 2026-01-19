# frozen_string_literal: true

module SalesTax
  module Receipt
    # Formats a Receipt as a string for output.
    class Printer
      def print(receipt)
        lines = receipt.line_items.map { |line_item| format_line_item(line_item) }
        lines << "Sales Taxes: #{format_currency(receipt.total_tax)}"
        lines << "Total: #{format_currency(receipt.total)}"
        lines.join("\n")
      end

      private

      def format_line_item(line_item)
        "#{line_item.quantity} #{line_item.name}: #{format_currency(line_item.total_price)}"
      end

      def format_currency(amount)
        format('%.2f', amount)
      end
    end
  end
end
