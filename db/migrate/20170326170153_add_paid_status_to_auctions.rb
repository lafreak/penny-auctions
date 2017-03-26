class AddPaidStatusToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :paid, :boolean, :default => false
  end
end
