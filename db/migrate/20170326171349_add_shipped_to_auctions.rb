class AddShippedToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :shipped, :boolean, :default => false
  end
end
