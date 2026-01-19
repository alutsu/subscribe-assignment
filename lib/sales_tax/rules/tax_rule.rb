# frozen_string_literal: true

module SalesTax
  module Rules
    # Base class for tax rules. Subclasses must implement #applicable? and #rate.
    class TaxRule
      def applicable?(_item)
        raise NotImplementedError, "#{self.class} must implement #applicable?"
      end

      def rate
        raise NotImplementedError, "#{self.class} must implement #rate"
      end

      def calculate(item)
        return 0.0 unless applicable?(item)

        item.subtotal * rate
      end
    end
  end
end
