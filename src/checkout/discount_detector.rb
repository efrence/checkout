module Checkout
  class DiscountDetector
    def initialize(products)
      @products = products
    end

    def add_product(product)
      @products << product
    end

    def detect_specials
      specials = []
      sparse = []
      get_specials.each do |special|
        specials.concat send("#{special}_special")
      end
      specials = specials.sort_by {|h| h['index'] }
      specials.each do |special|
        idx = special['index']
        if sparse[idx].nil?
          sparse[idx] = []
        end
        sparse[idx] << {code: special['code'], amount: special['amount'], discount_type: special['discount_type']}
      end
      sparse
    end

    private

    def get_specials
      specials = private_methods(false).map do |m|
        keywords = m.to_s.split('_')
        if  keywords[1] == 'special'
          keywords[0]
        end
      end
      specials.compact
    end

    def bogo_special
      counts = {}
      discounts = []
      for i in 0..(@products.size - 1)
        product = @products[i]
        if counts[product].nil?
          counts[product] = 1
        else
          counts[product] += 1
          if product == 'CF1' && counts[product] % 2 == 0
            discount = {}
            discount['code'] = 'BOGO'
            discount['index'] = i
            discount['amount'] = 100
            discount['discount_type'] = :percentage
            discounts << discount
          end
        end
      end
      discounts
    end

    def appl_special
      counter = 0
      indices = []
      satisfied = false
      discounts = []
      for i in 0..(@products.size - 1)
        product = @products[i]
        if product == 'AP1'
          counter += 1
          indices << i
        end
        satisfied = true if counter > 2
      end
      return discounts unless satisfied

      indices.each do |idx|
        discount = {}
        discount['code'] = 'APPL'
        discount['index'] = idx
        discount['amount'] = 4.5
        discount['discount_type'] = :fixed
        discounts << discount
      end
      discounts
    end

    def chmk_special
      milk_ind = nil
      chai_ind = nil
      for i in 0..(@products.size - 1)
        product = @products[i]
        if product == 'CH1'
          chai_ind ||= i
          if milk_ind
            discount = {}
            discount['code'] = 'CHMK'
            discount['amount'] = 100
            discount['discount_type'] = :percentage
            discount['index'] = milk_ind
            return [discount]
          end
        elsif product == 'MK1'
          milk_ind ||= i
          if chai_ind
            discount = {}
            discount['code'] = 'CHMK'
            discount['amount'] = 100
            discount['discount_type'] = :percentage
            discount['index'] = milk_ind
            return [discount]
          end
        end
      end
      []
    end
  end
end
