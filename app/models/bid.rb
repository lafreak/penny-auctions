class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :user

  validates :user, presence: true
  validates :auction, presence: true

  validates_numericality_of :price, :greater_than_or_equal_to => 0.01
end
