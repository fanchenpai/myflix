class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email, :full_name, :message, :token
      t.integer :user_id, :new_user_id

      t.timestamps
    end
  end
end
