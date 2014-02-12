class CreateFollowership < ActiveRecord::Migration
  def change
    create_table :followerships do |t|
      t.integer :user_id, :follower_id
      t.timestamps
    end
  end
end
