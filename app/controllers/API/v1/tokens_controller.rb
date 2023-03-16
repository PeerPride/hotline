# frozen_string_literal: true

module API
  module V1
    class TokensController < API::BaseController # :nodoc:
      def get
        identity = 'user'

        # Create Voice grant for our token
        grant = Twilio::JWT::AccessToken::VoiceGrant.new
        grant.outgoing_application_sid = ENV['TWILIO_APP_ID']

        # Optional: add to allow incoming calls
        grant.incoming_allow = true

        # Create an Access Token
        token = Twilio::JWT::AccessToken.new(
          ENV['TWILIO_ACCOUNT_SID'],
          ENV['TWILIO_API_KEY'],
          ENV['TWILIO_API_SECRET'],
          [grant],
          identity: identity
        )

        render json: { token: token.to_jwt }, status: :created
      end
    end
  end
end
