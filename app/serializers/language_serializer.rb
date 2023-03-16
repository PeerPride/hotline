# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string
#  is_active  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LanguageSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :is_active
end
