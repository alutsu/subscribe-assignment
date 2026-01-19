# frozen_string_literal: true

# Rules
require_relative 'sales_tax/rules/tax_rule'
require_relative 'sales_tax/rules/basic_tax_rule'
require_relative 'sales_tax/rules/import_tax_rule'
# Receipt
require_relative 'sales_tax/receipt/line_item'
require_relative 'sales_tax/receipt/receipt'
require_relative 'sales_tax/receipt/printer'
# Core
require_relative 'sales_tax/item'
require_relative 'sales_tax/input_parser'
require_relative 'sales_tax/tax_calculator'
require_relative 'sales_tax/shopping_basket'
