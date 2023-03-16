class AddCategoryReferenceToConversation < ActiveRecord::Migration[7.0]
  def change
    add_reference :conversations, :conversation_category, null: true, foreign_key: true
  end
end
