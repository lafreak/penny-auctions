require "rails_helper"

RSpec.describe Auction, :type => :model do
  let(:auction) { Auction.new(name: 'MacBook Pro 20') }

  it "is valid" do
    expect(auction).to be_valid
  end

  it "is invalid with no name" do
    auction.name = nil
    expect(auction).not_to be_valid
  end

  it "has default top_price" do
    expect(auction.top_price).to eq 0.01
  end

  it "has default paid status" do
    expect(auction.paid).to eq false
  end

  it "has default shipped status" do
    expect(auction.shipped).to eq false
  end

  it "has default premium status" do
    expect(auction.premium).to eq false
  end

  describe "#top_offer" do
    it "returns 0.01 if no bids were made" do
      auction.save
      expect(auction.top_offer).to eq 0.01
    end

    it "returns highest bid price if any" do
      auction.save

      bid1 = Bid.create!(auction: auction, user: User.new, price: 1.14)
      bid2 = Bid.create!(auction: auction, user: User.new, price: 1.84)
      bid3 = Bid.create!(auction: auction, user: User.new, price: 1.54)

      expect(auction.top_offer).to eq 1.84
    end
  end

  describe "#highest_bid" do
    it "returns no bid if has no bids" do
      auction.save
      expect(auction.highest_bid).to be_nil
    end

    it "returns bid with highest price" do
      auction.save

      bid1 = Bid.create!(auction: auction, user: User.new, price: 1.14)
      bid2 = Bid.create!(auction: auction, user: User.new, price: 1.84)
      bid3 = Bid.create!(auction: auction, user: User.new, price: 1.54)

      expect(auction.highest_bid).to eq bid2
    end
  end
end