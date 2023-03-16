# frozen_string_literal: true
# rubocop:disable Rails/BulkChangeTable
# rubocop:disable Metrics/MethodLength

class AddDetailsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :on_call_name, :string
    add_column :users, :pronouns, :string
    add_column :users, :bio, :text
    add_column :users, :phone_number, :string
    add_column :users, :timezone, :string, default: 'America/New_York'
    add_column :users, :break_between_conversations, :integer, limit: 2, default: 300
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    add_index :users, :confirmation_token, unique: true
    add_column :users, :remember_created_at, :datetime
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :users, :locked_at, :datetime
  end
end
