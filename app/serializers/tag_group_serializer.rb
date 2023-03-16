# == Schema Information
#
# Table name: tag_groups
#
#  id              :bigint           not null, primary key
#  subject         :string
#  conversation_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tag_groups_on_conversation_id  (conversation_id)
#
class TagGroupSerializer
  include JSONAPI::Serializer

  #has_many :tag_instances, serializer: :tag_instance

  attributes :id, :conversation_ids
  attribute :tag_instances do |object|
    object.tag_instances.as_json
  end
end
