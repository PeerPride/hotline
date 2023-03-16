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
require 'rails_helper'

RSpec.describe Conversation do
  pending "add some examples to (or delete) #{__FILE__}"
end
