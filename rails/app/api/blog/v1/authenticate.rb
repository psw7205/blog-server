module Blog
  module V1
    module Authenticate
      extend ActiveSupport::Concern

      def self.auth_headers
        {
          Authorization: {
            description: 'Validates identity through JWT provided in auth/login',
            required: true
          }
        }
      end

      included do
        helpers do
          def current_user
            @user
          end

          def jwt_token
            token = headers['Authorization']
            error!(error_message(401, 'Unauthorized'), :unauthorized) if token.blank?

            token.include?('Bearer') ? token.split[1] : token
          end

          def authenticate!
            token = jwt_token
            header('Authorization', "Bearer #{token}")

            @user = Warden::JWTAuth::UserDecoder.new.call(
              token, :user, Warden::JWTAuth.config.aud_header
            )
          end

          def generate_token(user)
            Warden::JWTAuth::UserEncoder.new.call(
              user, :user, Warden::JWTAuth.config.aud_header
            )
          end

          def revoke_token(token)
            Warden::JWTAuth::TokenRevoker.new.call(token)
          end
        end
      end
    end
  end
end
