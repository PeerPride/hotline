# frozen_string_literal: true

module API
  module V1
    class TagcategoriesController < API::BaseController # :nodoc:
      def index
        render_jsonapi_collection_response TagCategory.all
      end

      def show
        category = TagCategory.find(params[:id])
        render_jsonapi_response(category)
      end

      def create
        if TagCategoryPolicy.new(current_user, nil).create?
          cat = TagCategory.new(permitted_params)
          cat.save!
          render_jsonapi_response(cat)
        else
          head :unauthorized
        end
      end

      def update
        category = TagCategory.find(params[:id])

        if TagCategoryPolicy.new(current_user, category).update?
          category.update!(params.require(:tagcategory).permit(:name, :description, :is_active))
          render_jsonapi_response(category)
        else
          head :unauthorized
        end
      end

      def all_with_tags
        categories = TagCategory.all
        render_jsonapi_collection_response(categories)
      end

      private

      def permitted_params
        params.require(:tagcategory).permit(:name, :description, :is_active)
      end
    end
  end
end
