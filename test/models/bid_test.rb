require 'test_helper'

class BidTest < ActiveSupport::TestCase
  def setup
    @bid = Bid.new(
      user: User.new,
      auction: Auction.new,
      price: 1.14
    )
  end

  test "should be valid" do
    assert @bid.valid?
  end

  test "should be invalid due to price" do
    @bid.price = BigDecimal.new(0, 2)
    assert_not @bid.valid?
  end
  
  test "should be invalid due to user absence" do
    @bid.user = nil
    assert_not @bid.valid?
  end

  test "should be invalid due to auction absence" do
    @bid.auction = nil
    assert_not @bid.valid?
  end
end
