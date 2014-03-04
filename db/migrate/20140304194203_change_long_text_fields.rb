class ChangeLongTextFields < ActiveRecord::Migration
  def change
    change_column :videos, :description, :text, limit: nil
    change_column :reviews, :detail, :text, limit: nil
    change_column :invitations, :message, :text, limit: nil
  end
end
