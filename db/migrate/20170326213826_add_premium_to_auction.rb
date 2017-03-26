class AddPremiumToAuction < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :premium, :boolean, :default => false
  end
end
