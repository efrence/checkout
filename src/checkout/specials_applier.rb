module Checkout
  class SpecialsApplier
    def initialize(discount_detector_class, products=[])
      @products = products
      @detector_class = discount_detector_class
    end

    def add_product(product)
      @products << product
    end

    def products_with_discounts
      @detector = @detector_class.new([])
      @products.map do |p|
        @detector.add_product p['product_code']
      end
      @discounts = @detector.detect_specials
      relation = []
      for i in 0..(@products.size - 1)
        product = @products[i]
        relation << product
        @discounts[i] && @discounts[i].each do |discount|
          discount_hash = {}
          discount_hash['price'] = percentage_amount(discount[:amount], product['price']) if discount[:discount_type] == :percentage
          discount_hash['price'] = fixed_amount(discount[:amount], product['price']) if discount[:discount_type] == :fixed
          discount_hash['discount_code'] = discount[:code]
          discount_hash['product_code'] = ''
          relation << discount_hash
        end
      end
      relation
    end

    private

    def percentage_amount(percentage, price)
      factor = (100.0 - percentage) / 100
      return price * -1 if factor == 0.0

      factor * price * -1
    end

    def fixed_amount(target_price, price)
      (price - target_price) * -1
    end
  end
end
