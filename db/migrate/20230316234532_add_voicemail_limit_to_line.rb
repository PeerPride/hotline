class AddVoicemailLimitToLine < ActiveRecord::Migration[7.0]
  def change
    add_column :lines, :voicemail_per_day_limit, :integer, :default => 1
  end
end
