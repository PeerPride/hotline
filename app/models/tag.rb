# == Schema Information
#
# Table name: tags
#
#  id              :bigint           not null, primary key
#  name            :string
#  description     :string
#  is_active       :boolean          default(TRUE)
#  item_order      :integer
#  tag_category_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tags_on_tag_category_id  (tag_category_id)
#
class Tag < ApplicationRecord
  validates :name, presence: true
  belongs_to :tag_category
  has_many :tag_instances
end
