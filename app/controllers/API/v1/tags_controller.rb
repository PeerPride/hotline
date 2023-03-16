# frozen_string_literal: true

module API
  module V1
    class TagsController < API::BaseController # :nodoc:
      def index
        render_jsonapi_collection_response Tag.all
      end

      def show
        tag = Tag.find(params[:id])
        render_jsonapi_response(tag)
      end

      def create
        if TagPolicy.new(current_user, nil).create?
          tag = Tag.create!(params.require(:tag).permit(:name, :description, :is_active, :tag_category_id))
          render_jsonapi_response(tag)
        else
          head :unauthorized
        end
      end

      def update
        tag = Tag.find(params[:id])

        if TagPolicy.new(current_user, line).update?
          tag.update!(params.require(:tag).permit(:name, :description, :is_active, :tagcategory_id))
          render_jsonapi_response(tag)
        else
          head :unauthorized
        end
      end
    end
  end
end
