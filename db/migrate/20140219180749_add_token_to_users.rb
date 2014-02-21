class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_token, :string
    add_column :users, :password_token_timestamp, :datetime
  end
end
