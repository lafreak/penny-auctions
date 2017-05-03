require "rails_helper"

RSpec.describe Bid, :type => :model do
  let(:bid) { Bid.new(user: User.new, auction: Auction.new, price: 1.14) }

  it "is valid" do
    expect(bid).to be_valid
  end

  it "is invalid with negative price" do
    bid.price = BigDecimal.new -1.5, 2
    expect(bid).not_to be_valid
  end

  it "is invalid with zero price" do
    bid.price = BigDecimal.new 0, 2
    expect(bid).not_to be_valid
  end

  it "is invalid with no user" do
    bid.user = nil
    expect(bid).not_to be_valid
  end

  it "is invalid with no auction" do
    bid.auction = nil
    expect(bid).not_to be_valid
  end
end