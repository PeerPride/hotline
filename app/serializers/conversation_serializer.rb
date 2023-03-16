# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id                       :bigint           not null, primary key
#  method                   :string
#  notes                    :text
#  provider_id              :string
#  length                   :integer
#  started_at               :datetime
#  ended_at                 :datetime
#  status                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  contact_phone_id         :bigint           not null
#  conversation_category_id :bigint
#
# Indexes
#
#  index_conversations_on_contact_phone_id          (contact_phone_id)
#  index_conversations_on_conversation_category_id  (conversation_category_id)
#
class ConversationSerializer
  include JSONAPI::Serializer

  belongs_to :contact, serializer: :contact
  belongs_to :contact_phone, serializer: :contact_phone
  belongs_to :conversation_category, serializer: :conversation_category
  has_many :tag_groups, serializer: :tag_group
  #@has_many :tag_instances, through: :tag_groups, serializer: :tag_instance

  attributes :id, :method, :notes, :provider_id, :length, :started_at, :ended_at, :status, :conversation_category_id,
             :contact, :contact_phone, :conversation_category

  attribute :tag_groups do |object|
    object.deep_tag_groups
  end
end
