class AddSpecialToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :special, :boolean, :default => false
  end
end
