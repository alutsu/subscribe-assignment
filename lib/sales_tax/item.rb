# frozen_string_literal: true

module SalesTax
  # Represents a product in the shopping basket.
  # Determines if an item is imported or exempt from basic tax.
  class Item
    BOOK_KEYWORDS = %w[book].freeze
    FOOD_KEYWORDS = %w[chocolate chocolates candy].freeze
    MEDICAL_KEYWORDS = %w[pills headache pill medicine vitamin].freeze

    attr_reader :quantity, :name, :unit_price

    def initialize(quantity:, name:, unit_price:)
      @quantity = quantity
      @name = name.freeze
      @unit_price = unit_price
      freeze
    end

    def imported?
      name.downcase.include?('imported')
    end

    # Books, food, and medical products are exempt from basic tax
    def exempt?
      book? || food? || medical?
    end

    def subtotal
      quantity * unit_price
    end

    private

    def book?
      matches_keywords?(BOOK_KEYWORDS)
    end

    def food?
      matches_keywords?(FOOD_KEYWORDS)
    end

    def medical?
      matches_keywords?(MEDICAL_KEYWORDS)
    end

    def matches_keywords?(keywords)
      name_words = name.downcase.split(/\s+/)
      keywords.any? { |keyword| name_words.any? { |word| word.include?(keyword) } }
    end
  end
end
