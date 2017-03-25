class RemoveAuctionPrice < ActiveRecord::Migration[5.0]
  def change
    remove_column :auctions, :price
  end
end
