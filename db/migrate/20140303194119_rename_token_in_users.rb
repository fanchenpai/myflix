class RenameTokenInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :password_token, :token
    rename_column :users, :password_token_timestamp, :token_timestamp
  end
end
