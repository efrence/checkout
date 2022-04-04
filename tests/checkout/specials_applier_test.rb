require "minitest/autorun"
require_relative '../../main'

class TestSpecialsAplier < Minitest::Test
  def setup
    @applier = Checkout::SpecialsApplier.new Checkout::DiscountDetector
  end

  def test_empty_case
    assert_equal @applier.products_with_discounts, []
  end

  def test_with_no_specials
    @applier.add_product apple
    @applier.add_product apple
    assert_equal @applier.products_with_discounts, [apple, apple]
  end

  def test_with_bogo_special
    @applier.add_product coffee
    assert_equal @applier.products_with_discounts, [coffee]
    @applier.add_product coffee
    assert @applier.products_with_discounts != [coffee, coffee]
    coffee_discount = {"price"=>-11.23, "discount_code"=>"BOGO", "product_code"=>""}
    assert_equal @applier.products_with_discounts, [coffee, coffee, coffee_discount]
  end

  def test_with_appl_special
    @applier.add_product apple
    @applier.add_product apple
    assert_equal @applier.products_with_discounts, [apple, apple]
    @applier.add_product apple
    apple_discount = {"price"=>-1.5, "discount_code"=>"APPL", "product_code"=>""}
    assert @applier.products_with_discounts != [apple, apple, apple]
    assert_equal @applier.products_with_discounts, [apple, apple_discount, apple, apple_discount, apple, apple_discount]
  end

  def test_with_chmk_special
    @applier.add_product chai
    assert_equal @applier.products_with_discounts, [chai]
    @applier.add_product milk
    assert @applier.products_with_discounts != [chai, milk]
    milk_discount = {"price"=>-4.75, "discount_code"=>"CHMK", "product_code"=>""}
    assert_equal @applier.products_with_discounts, [chai, milk, milk_discount]
  end

  def test_with_appl_and_chmk_specials
    @applier.add_product chai
    assert_equal @applier.products_with_discounts, [chai]
    @applier.add_product apple
    assert_equal @applier.products_with_discounts, [chai, apple]
    @applier.add_product apple
    assert_equal @applier.products_with_discounts, [chai, apple, apple]
    @applier.add_product apple
    apple_discount = {"price"=>-1.5, "discount_code"=>"APPL", "product_code"=>""}
    assert_equal @applier.products_with_discounts, [chai, apple, apple_discount, apple, apple_discount, apple, apple_discount]
    @applier.add_product milk
    milk_discount = {"price"=>-4.75, "discount_code"=>"CHMK", "product_code"=>""}
    assert_equal @applier.products_with_discounts, [chai, apple, apple_discount, apple, apple_discount, apple, apple_discount, milk, milk_discount]
  end
end
