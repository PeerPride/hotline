# frozen_string_literal: true

module API
  module V1
    class ConversationcategoriesController < API::BaseController # :nodoc:
      def index
        render_jsonapi_collection_response ConversationCategory.all
      end

      def show
        render_jsonapi_response(ConversationCategory.find(params[:id]))
      end

      def create
        cat = ConversationCategory.new(permitted_params)
        cat.save!
        render_jsonapi_response(cat)
      end

      def update
        cat = ConversationCategory.find(params[:id])
        cat.update!(permitted_params)
        render_jsonapi_response(cat)
      end

      private

      def permitted_params
        params.require(:category).permit(:name, :description, :is_active)
      end
    end
  end
end
