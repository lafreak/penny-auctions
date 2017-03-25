class Auction < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  has_many :bids

  def top_offer
    return BigDecimal.new(0.01, 2) if bids.count == 0
    bids.order('price DESC').limit(1).first.price
  end
end
