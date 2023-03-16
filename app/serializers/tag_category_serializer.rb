# == Schema Information
#
# Table name: tag_categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  item_order  :integer
#  is_active   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TagCategorySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :is_active, :tags
end
