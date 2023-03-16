# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.string :method
      t.text :notes
      t.string :provider_id
      t.integer :length
      t.datetime :started_at
      t.datetime :ended_at
      t.string :status

      t.timestamps
    end
  end
end
