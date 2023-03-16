class CreateTagInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_instances do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :tag_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
