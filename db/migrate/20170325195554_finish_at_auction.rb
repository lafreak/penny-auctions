class FinishAtAuction < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :finish_at, :datetime
  end
end
