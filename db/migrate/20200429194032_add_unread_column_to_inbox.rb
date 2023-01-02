class AddUnreadColumnToInbox < ActiveRecord::Migration[5.0]
  def change
    add_column :inboxes, :unread, :integer, default: 0
  end
end
