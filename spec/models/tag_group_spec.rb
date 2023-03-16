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
require 'rails_helper'

RSpec.describe TagGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
