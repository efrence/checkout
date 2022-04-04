require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir("src")
loader.setup

def apple
  ProductCatalog.apple
end

def coffee
  ProductCatalog.coffee
end

def milk
  ProductCatalog.milk
end

def chai
  ProductCatalog.chai
end

products = [chai, apple, coffee, milk]
products = [coffee, coffee]
products = [milk, apple]
products = [apple, apple, chai, apple]
products = [chai, milk]

evaluator = Checkout::SpecialsApplier.new Checkout::DiscountDetector
cart = Checkout::Cart.new evaluator, Checkout::Printer, products
#cart.add(milk)
#cart.show

