class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.references :user
      t.references :auction
      t.decimal :price, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end
  end
end
