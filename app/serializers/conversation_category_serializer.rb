# frozen_string_literal: true

# == Schema Information
#
# Table name: conversation_categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  is_active   :boolean          default(TRUE)
#  item_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ConversationCategorySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :is_active, :item_order
end
