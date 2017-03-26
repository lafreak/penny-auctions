class EditTopPriceDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :auctions, :top_price, :decimal, :precision => 8, :scale => 2, :default => 0.01, :null => false
  end
end
