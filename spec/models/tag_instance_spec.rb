# == Schema Information
#
# Table name: tag_instances
#
#  id           :bigint           not null, primary key
#  tag_id       :bigint           not null
#  tag_group_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_tag_instances_on_tag_group_id  (tag_group_id)
#  index_tag_instances_on_tag_id        (tag_id)
#
require 'rails_helper'

RSpec.describe TagInstance, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
