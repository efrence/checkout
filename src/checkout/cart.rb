module Checkout
  class Cart
    def initialize(discount_evaluator, printer, products=[])
      @discount_evaluator = discount_evaluator
      @printer = printer
      @products = products
    end

    def add(product)
      @products << product
    end

    def show
      prepare
      products_with_discounts = @discount_evaluator.products_with_discounts
      total = total products_with_discounts
      products_with_discounts << {product_code: '----', price: '-----'}
      products_with_discounts << {product_code: '', price: total}
      show_discount_codes = @products.size != (products_with_discounts.size - 2)
      products_with_discounts = fill_missing_columns(products_with_discounts) if show_discount_codes
      @printer.display products_with_discounts, show_discount_codes
    end

    private

    def prepare
      @products.map do |product|
        @discount_evaluator.add_product product
      end
    end

    def total(products)
      products.map {|p| p['price'] }.compact.sum()
    end


    def fill_missing_columns(products)
      products.each do |p|
        p['discount_code'] = '' if p['discount_code'].nil?
      end
      products
    end
  end
end

