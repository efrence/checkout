require "minitest/autorun"
require_relative '../../main'

class TestDiscountDetector < Minitest::Test
  def setup
    @detector = Checkout::DiscountDetector.new []
  end

  def test_empty_case
    assert_equal @detector.detect_specials, []
  end

  def test_with_random_products
    @detector.add_product 'AA'
    @detector.add_product 'BB'
    assert_equal @detector.detect_specials, []
  end

  def test_with_bogo_discount
    @detector.add_product 'CF1'
    @detector.add_product 'CF1'
    assert_equal @detector.detect_specials, [nil, [{:code=>"BOGO", :amount=>100, :discount_type=>:percentage}]]
  end

  def test_with_chmk_discount
    @detector.add_product 'CH1'
    @detector.add_product 'MK1'
    assert_equal @detector.detect_specials, [nil, [{:code=>"CHMK", :amount=>100, :discount_type=>:percentage}]]
  end


  def test_with_bogo_and_chmk_discounts
    @detector.add_product 'CH1'
    @detector.add_product 'AP1'
    @detector.add_product 'AP1'
    @detector.add_product 'AP1'
    @detector.add_product 'MK1'
    assert_equal @detector.detect_specials, [nil, [{:code=>"APPL", :amount=>4.5, :discount_type=>:fixed}], [{:code=>"APPL", :amount=>4.5, :discount_type=>:fixed}], [{:code=>"APPL", :amount=>4.5, :discount_type=>:fixed}], [{:code=>"CHMK", :amount=>100, :discount_type=>:percentage}]]
  end
end
