module Blog
  module V1
    class Base < Grape::API
      format :json
      version 'v1', using: :path
      prefix :api

      helpers do
        def error_message(code, message)
          {
            error: {
              code: code,
              message: message
            }
          }
        end
      end

      # global handler for simple not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        Rails.logger.error(e)
        error!(error_message(404, 'Not Found'), 404)
      end

      rescue_from JWT::DecodeError do |e|
        Rails.logger.error(e)
        error!(error_message(401, e.to_s), 401)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!(error_message(400, e.full_messages[0]), 400)
      end

      # global exception handler, used for error notifications
      rescue_from :all do |e|
        Rails.logger.error(e)
        error!(error_message(500, "Internal Server Error: #{e.to_s}"), 500)
      end

      mount Blog::V1::Users
      mount Blog::V1::Posts
      mount Blog::V1::Comments
    end
  end
end
