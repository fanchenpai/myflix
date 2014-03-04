class AddTokenTimestampToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :token_timestamp, :datetime
  end
end
