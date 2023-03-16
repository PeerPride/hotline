class AddContactReferenceToConversation < ActiveRecord::Migration[7.0]
  def change
    add_reference :conversations, :contact_phone, null: false, foreign_key: true
  end
end
