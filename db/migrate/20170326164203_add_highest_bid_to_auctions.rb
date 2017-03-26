class AddHighestBidToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_reference :auctions, :user
    add_column :auctions, :top_price, :decimal, :precision => 8, :scale => 2, :default => 0.1, :null => false
  end
end
