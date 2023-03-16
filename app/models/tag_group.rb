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
class TagGroup < ApplicationRecord

  belongs_to :conversation

  has_many :tag_instances, dependent: :destroy

end
