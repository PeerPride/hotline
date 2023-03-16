# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email                       :string           default(""), not null
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string
#  last_sign_in_ip             :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  name                        :string
#  on_call_name                :string
#  pronouns                    :string
#  bio                         :text
#  phone_number                :string
#  timezone                    :string           default("America/New_York")
#  break_between_conversations :integer          default(300)
#  confirmation_token          :string
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string
#  remember_created_at         :datetime
#  failed_attempts             :integer          default(0)
#  unlock_token                :string
#  locked_at                   :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_phone_number          (phone_number) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :phone_number, :name, :on_call_name, :timezone, :break_between_conversations,
             :last_sign_in_at, :bio, :pronouns, :languages
end
