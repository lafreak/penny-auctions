class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
