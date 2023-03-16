class CreateTagCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_categories do |t|
      t.string :name
      t.string :description
      t.integer :item_order
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
