class AddIndexesOnLineContact < ActiveRecord::Migration[7.0]
  def change
    add_index :lines, :name, unique: true

    add_index :contacts, :codename, unique: true
    add_index :contact_phones, :phone
  end
end
