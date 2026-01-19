# frozen_string_literal: true

module SalesTax
  # Parses input lines in format: "<quantity> <name> at <price>"
  class InputParser
    INPUT_PATTERN = /^(\d+)\s+(.+)\s+at\s+(\d+\.\d{2})$/

    def parse(input)
      input
        .lines
        .map(&:strip)
        .reject(&:empty?)
        .map { |line| parse_line(line) }
    end

    def parse_line(line)
      match = INPUT_PATTERN.match(line)
      raise ArgumentError, "Invalid input format: '#{line}'" unless match

      Item.new(
        quantity: match[1].to_i,
        name: match[2].strip,
        unit_price: match[3].to_f
      )
    end
  end
end
