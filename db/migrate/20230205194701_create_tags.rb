class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :description
      t.boolean :is_active, default: true
      t.integer :item_order
      t.references :tag_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
