# frozen_string_literal: true

class CreateLines < ActiveRecord::Migration[7.0]
  def change
    create_table :lines do |t|
      t.string :name
      t.string :number
      t.boolean :is_active, default: true
      t.string :phone_greeting_message
      t.string :greeting_audio
      t.boolean :record_calls, default: true
      t.integer :recording_save_length, default: 365

      t.index :number
      t.timestamps
    end
  end
end
