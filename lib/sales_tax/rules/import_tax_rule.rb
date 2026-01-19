# frozen_string_literal: true

module SalesTax
  module Rules
    # 5% import duty on all imported goods
    class ImportTaxRule < TaxRule
      RATE = 0.05

      def rate
        RATE
      end

      def applicable?(item)
        item.imported?
      end
    end
  end
end
