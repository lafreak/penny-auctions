class RemoveSpecialFromAuction < ActiveRecord::Migration[5.0]
  def change
    remove_column :auctions, :special
  end
end
