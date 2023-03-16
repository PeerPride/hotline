# frozen_string_literal: true

module API
  module V1
    class LinesController < API::BaseController # :nodoc:
      def index
        render_jsonapi_collection_response Line.all
      end

      def show
        line = Line.find(params[:id])
        render_jsonapi_response(line)
      end

      def create
        if LinePolicy.new(current_user, nil).create?
          Line.create!(params.require(:line).permit(:name, :number, :is_active, :phone_greeting_message,
                                                    :greeting_audio, :record_calls, :recording_save_length, :accepts_phone_calls, :accepts_text_messages, :accepts_voicemails, :voicemail_greeting, :phone_greeting_message, :no_operators_phone_message, :no_operators_text_message))

        else
          head :unauthorized
        end
      end

      def update
        line = Line.find(params[:id])

        if LinePolicy.new(current_user, line).update?
          line.update!(params.require(:line).permit(:name, :number, :is_active, :phone_greeting_message,
            :greeting_audio, :record_calls, :recording_save_length, :accepts_phone_calls, :accepts_text_messages, :accepts_voicemails, :voicemail_greeting, :phone_greeting_message, :no_operators_phone_message, :no_operators_text_message))
          render_jsonapi_response(line)
        else
          head :unauthorized
        end
      end
    end
  end
end
