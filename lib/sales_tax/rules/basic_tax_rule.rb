# frozen_string_literal: true

module SalesTax
  module Rules
    # 10% tax on non-exempt goods
    class BasicTaxRule < TaxRule
      RATE = 0.10

      def rate
        RATE
      end

      def applicable?(item)
        !item.exempt?
      end
    end
  end
end
