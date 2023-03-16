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
class Contact < ApplicationRecord
  include CodenameGeneratorHelper
  validates :codename, presence: true, uniqueness: { case_insensitive: false }

  before_validation :set_codename, on: [:create]

  has_many :contact_phones, dependent: :destroy
  has_many :conversations

  private

  def set_codename
    cn = ''
    loop do
      cn = generate_codename
      break if Contact.where(codename: cn).count.zero?
    end

    self.codename = cn
  end
end
