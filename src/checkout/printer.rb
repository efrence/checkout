require 'table_print'

module Checkout
  class Printer
    def self.display(products, show_discount_codes=false)
      tp.set :separator, '           '
      tp.set :capitalize_headers, false
      tp.set :max_width, 20
      tp.set Hash, except: 'name'
      tp products, :product_code, :discount_code, :price if show_discount_codes
      tp products, :product_code, :price unless show_discount_codes
    end
  end
end
