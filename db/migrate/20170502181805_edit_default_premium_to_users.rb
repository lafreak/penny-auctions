class EditDefaultPremiumToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :premium, :datetime, :default => DateTime.new(2000, 1, 1)
  end
end
