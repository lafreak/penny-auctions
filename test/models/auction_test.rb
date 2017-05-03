require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  def setup
    @auction = Auction.new(name: 'MacBook Pro 20')
  end

  test "should be valid" do
    assert @auction.valid?
  end

  test "should be invalid with no name" do
    @auction.name = nil
    assert_not @auction.valid?
  end

  test "should have valid default values" do
    assert_equal 0.01, @auction.top_price
    assert_equal false, @auction.paid
    assert_equal false, @auction.shipped
    assert_equal false, @auction.premium
  end
end
