# frozen_string_literal: true

# == Schema Information
#
# Table name: contact_phones
#
#  id         :bigint           not null, primary key
#  contact_id :bigint
#  phone      :string
#  city       :string
#  state      :string
#  zip        :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contact_phones_on_contact_id  (contact_id)
#  index_contact_phones_on_phone       (phone)
#
class ContactPhone < ApplicationRecord
  validates :phone, uniqueness: true

  def phone_number=(val)
    self[:phone] = Phonelib.parse(val).international
  end

  belongs_to :contact
  has_many :conversation
end
