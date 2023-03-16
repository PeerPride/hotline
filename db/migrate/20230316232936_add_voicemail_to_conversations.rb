class AddVoicemailToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :recording_id, :string
    add_column :conversations, :is_voicemail, :boolean, :default => false
    add_column :conversations, :voicemail_acknowledged, :timestamp
  end
end
