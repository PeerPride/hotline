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
require 'rails_helper'

RSpec.describe ConversationCategory do
  pending "add some examples to (or delete) #{__FILE__}"
end
