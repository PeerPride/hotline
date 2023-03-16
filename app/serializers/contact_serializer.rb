# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  codename   :string
#  notes      :text
#  blocked    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contacts_on_codename  (codename) UNIQUE
#
class ContactSerializer
  include JSONAPI::Serializer
  attributes :id, :codename, :notes, :blocked
end
