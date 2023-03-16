class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :codename
      t.text :notes
      t.boolean :blocked, default: false

      t.timestamps
    end
  end
end
