# frozen_string_literal: true

# == Schema Information
#
# Table name: lines
#
#  id                         :bigint           not null, primary key
#  name                       :string
#  number                     :string
#  is_active                  :boolean          default(TRUE)
#  phone_greeting_message     :string
#  greeting_audio             :string
#  record_calls               :boolean          default(TRUE)
#  recording_save_length      :integer          default(365)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  accepts_phone_calls        :boolean          default(TRUE)
#  accepts_text_messages      :boolean          default(FALSE)
#  accepts_voicemails         :boolean          default(TRUE)
#  no_operators_phone_message :text
#  no_operators_text_message  :text
#  voicemail_greeting         :text
#  voicemail_per_day_limit    :integer          default(1)
#
# Indexes
#
#  index_lines_on_name    (name) UNIQUE
#  index_lines_on_number  (number)
#
class Line < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
