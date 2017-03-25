class AuctionPriceDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :auctions, :price, :decimal, :precision => 8, :scale => 2, :default => 0.1, :null => false
  end
end
