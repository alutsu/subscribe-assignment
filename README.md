# Sales Tax Calculator

A Ruby application that calculates sales taxes and generates receipts for shopping baskets.

## Problem

- **Basic sales tax**: 10% on all goods, except books, food, and medical products
- **Import duty**: 5% on all imported goods (no exemptions)
- **Rounding**: Tax is rounded up to the nearest 0.05

## Requirements

- Ruby 3.2+
- Bundler

## Setup

```bash
bundle install
```

## Usage

```bash
# Process a file
./bin/sales_tax examples/input_10.txt

# Process from stdin
cat examples/input_10.txt | ./bin/sales_tax
```

### Input Format

```
<quantity> <product name> at <price>
```

Example:
```
2 book at 12.49
1 music CD at 14.99
1 imported box of chocolates at 10.00
```

### Output

```
2 book: 24.98
1 music CD: 16.49
1 imported box of chocolates: 10.50
Sales Taxes: 2.00
Total: 47.97
```

## Tests

```bash
bundle exec rspec
```

## Structure

```
lib/sales_tax/
|-- item.rb              # Product with tax exemption logic
|-- input_parser.rb      # Parse text input
|-- tax_calculator.rb    # Calculate taxes with rounding
|-- shopping_basket.rb   # Main orchestrator
|-- rules/
|   |-- tax_rule.rb         # Base interface
|   |-- basic_tax_rule.rb   # 10% basic tax
|   |-- import_tax_rule.rb  # 5% import duty
|-- receipt/
    |-- line_item.rb    # Receipt line
    |-- receipt.rb      # Receipt data
    |-- printer.rb      # Format output
```

## Tax Exemptions

- **Books**: "book"
- **Food**: "chocolate", "chocolates", "candy"
- **Medical**: "pills", "headache", "medicine", "vitamin"
