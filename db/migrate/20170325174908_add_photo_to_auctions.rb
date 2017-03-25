class AddPhotoToAuctions < ActiveRecord::Migration[5.0]
  def change
    add_column :auctions, :photo, :string
  end
end
