class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages do |t|
      t.string :name
      t.boolean :is_active, default: true

      t.timestamps
    end

    create_table :languages_users, id: false do |t|
      t.belongs_to :language
      t.belongs_to :user
    end
  end
end
