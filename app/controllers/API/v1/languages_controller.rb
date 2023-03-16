# frozen_string_literal: true

module API
  module V1
    class LanguagesController < API::BaseController # :nodoc:
      def index
        render_jsonapi_collection_response Language.all
      end

      def show
        language = Language.find(params[:id])
        render_jsonapi_response(language)
      end

      def create
        #if LanguagePolicy.new(current_user, nil).create?
          language = Language.create!(params.require(:language).permit(:name, :is_active))
          render_jsonapi_response(language)
        #else
        #  head :unauthorized
        #end
      end

      def update
        language = Language.find(params[:id])

        #if LanguagePolicy.new(current_user, line).update?
          language.update!(params.require(:language).permit(:name, :is_active))
          render_jsonapi_response(language)
        #else
          #head :unauthorized
        #end
      end
    end
  end
end
