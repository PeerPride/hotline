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
class ContactPhoneSerializer
  include JSONAPI::Serializer
  attributes :id
end
