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
require 'rails_helper'

RSpec.describe TagCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
