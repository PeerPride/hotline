class CreateContactPhones < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_phones do |t|
      t.references :contact
      t.string :phone
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
