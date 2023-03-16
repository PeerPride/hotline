# frozen_string_literal: true

module API
  module V1
    class UsersController < API::BaseController # :nodoc:
      def index
        # render json: UserPolicy::Scope.new(current_user, User.all).resolve
        render_jsonapi_collection_response UserPolicy::Scope.new(current_user, User.all.order(:id)).resolve
      end

      def me
        # user = User.includes(:languages).find(current_user.id)
        user = User.find(current_user.id)
        if UserPolicy.new(current_user, user).show?
          render_jsonapi_response(user)
        else
          head :service_unavailable
        end
      end

      def show
        Rails.logger.debug params[:id]
        if params[:id] == 'me'
          # user = User.includes(:languages).find(current_user.id)
          user = User.find(current_user.id)
        elsif !User.exists?(params[:id])
          # user = User.includes(:languages).find(params[:id])

          render json: { error: 'not-found' }.to_json, status: :not_found and return
        else
          user = User.find(params[:id])
        end

        if UserPolicy.new(current_user, user).show?
          render_jsonapi_response(User.find(params[:id]))
        else
          head :unauthorized
        end
      end

      def update
        user = User.find(params[:id])

        if UserPolicy.new(current_user, user).update?
          user.update!(params.require(:user).permit(:email, :name, :phone_number, :pronouns, :bio, :on_call_name))
          render_jsonapi_response(User.find(params[:id]))
        else
          head :unauthorized
        end
      end

      def go_on_call
        user = if params[:id].nil?
                 current_user
               else
                 User.find(params[:id])
               end
        user.go_on_call
      end

      def go_off_call
        user = if params[:id].nil?
                 current_user
               else
                 User.find(params[:id])
               end
        user.go_off_call
      end

      def current_info
        status = {}
        status[:oncall] = OnCallManager.find_user(current_user.id)
        status[:id] = current_user.id

        render json: status
      end

      def oncall
        # if params[:language_id].present?
        render json: OnCallManager.on_call_for(params[:method], params[:language])
        # else
        # render_json_api_response(OnCallManager.on_call_for_language)
        # end
      end

      def invite
        user = User.new(invite_params)
        user.password = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
        user.save!
      end

      def invite_params
        params.require(:user).permit(:name, :phone_number, :email)
      end
    end
  end
end
