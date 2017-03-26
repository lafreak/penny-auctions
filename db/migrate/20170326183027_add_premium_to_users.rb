class AddPremiumToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :premium, :datetime, :default => DateTime.now
  end
end
