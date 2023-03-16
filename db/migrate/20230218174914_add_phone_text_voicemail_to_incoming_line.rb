class AddPhoneTextVoicemailToIncomingLine < ActiveRecord::Migration[7.0]
  def change
    add_column :lines, :accepts_phone_calls, :boolean, default: true
    add_column :lines, :accepts_text_messages, :boolean, default: false
    add_column :lines, :accepts_voicemails, :boolean, default: true
    add_column :lines, :no_operators_phone_message, :text
    add_column :lines, :no_operators_text_message, :text
    add_column :lines, :voicemail_greeting, :text
  end
end
