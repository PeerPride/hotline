class CreateConversationCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :conversation_categories do |t|
      t.string :name
      t.text :description
      t.boolean :is_active, default: true
      t.integer :item_order

      t.timestamps
    end
  end
end
