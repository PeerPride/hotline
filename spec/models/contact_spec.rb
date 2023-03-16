# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  codename   :string
#  notes      :text
#  blocked    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contacts_on_codename  (codename) UNIQUE
#
require 'rails_helper'

RSpec.describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
