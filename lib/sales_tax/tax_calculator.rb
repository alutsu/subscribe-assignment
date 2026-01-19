# frozen_string_literal: true

module SalesTax
  # Calculates taxes by applying all rules and rounding up to nearest 0.05.
  # Rounding is applied per unit, then multiplied by quantity.
  class TaxCalculator
    ROUNDING_INCREMENT = 0.05

    attr_reader :rules

    def initialize(rules: nil)
      @rules = (rules || default_rules).freeze
      freeze
    end

    def calculate_tax(item)
      unit_tax = calculate_unit_tax(item)
      rounded_unit_tax = round_tax(unit_tax)
      (rounded_unit_tax * item.quantity).round(2)
    end

    def calculate_total(item)
      item.subtotal + calculate_tax(item)
    end

    private

    def calculate_unit_tax(item)
      rules.sum { |rule| rule.applicable?(item) ? item.unit_price * rule.rate : 0.0 }
    end

    def default_rules
      [Rules::BasicTaxRule.new, Rules::ImportTaxRule.new]
    end

    def round_tax(amount)
      (amount / ROUNDING_INCREMENT).ceil * ROUNDING_INCREMENT
    end
  end
end
