# frozen_string_literal: true

module API
  # Route API calls through here
  class BaseController < ApplicationController
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def render_jsonapi_response(resource, include = [], fields = {})
      if resource.errors.empty?
        render jsonapi: resource, include:, fields:
      else
        render jsonapi_errors: resource.errors, status: :bad_request
      end
    end

    def render_jsonapi_collection_response(resources, include = [], fields = {})
      render jsonapi: resources, include:, fields:
    end

    rescue_from Exception do |exception|
      render json: exception, status: :internal_server_error
    end

    def not_found
      render json: {
        errors: [
          {
            status: '404',
            title: 'Not Found'
          }
        ]
      }, status: :not_found
    end
  end
end
