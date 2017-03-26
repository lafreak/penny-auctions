class Auction < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  has_many :bids, :dependent => :delete_all
  belongs_to :user

  def top_offer
    return BigDecimal.new(0.01, 2) if bids.count == 0
    bids.order('price DESC').limit(1).first.price
  end

  def highest_bid
    bids.order('price DESC').take(1).first
  end
end
