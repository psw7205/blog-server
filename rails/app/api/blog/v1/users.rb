module Blog
  module V1
    class Users < Grape::API
      include Blog::V1::Authenticate

      resource :users do
        desc 'Return user info' do
          headers Blog::V1::Authenticate.auth_headers
        end
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        route_param :id do
          get do
            authenticate!
            UserSerializer.new(User.find(params[:id]))
          end
        end

        desc 'Return list of users' do
          headers Blog::V1::Authenticate.auth_headers
        end

        params do
          optional :page, type: Integer
          optional :total, type: Integer
        end

        get do
          authenticate!

          page = params[:page] || 1
          total = params[:total] || 20

          options = {}
          options[:meta] = { total: total, page: page }

          UserSerializer.new(User.page(page).per(total), options)
        end

        desc 'Register user and return user object, access token'
        params do
          requires :email, type: String, desc: 'User Email'
          requires :password, type: String, desc: 'User Password'
        end

        post do
          user = User.new(email: params[:email], password: params[:password])

          if user.valid?
            user.save
            token, payload = generate_token(user)
            header('Authorization', "Bearer #{token}")
            UserSerializer.new(user)
          else
            error!(error_message(400, "Bad Request: #{user.errors.full_messages[0]}"), :bad_request)
          end
        end

        desc 'logout user' do
          success [code: 200, message: 'logout user']
          failure [code: 500, message: 'Internal Server Error']
          headers Blog::V1::Authenticate.auth_headers
        end
        delete 'logout' do
          revoke_token(jwt_token)
          status :ok
          { message: 'logout user' }
        end

        desc 'login user, return user object and jwt token' do
          success [code: 200, message: 'return User, jwt token']
          failure [code: 404, message: 'Not Found']
        end

        params do
          requires :email, type: String, desc: 'User Email'
          requires :password, type: String, desc: 'User Password'
        end

        post 'login' do
          email = params[:email]
          password = params[:password]
          user = User.find_by!(email: email)
          if user&.valid_password?(password)
            token, payload = generate_token(user)
            header('Authorization', "Bearer #{token}")
            status :ok
            UserSerializer.new(user)
          end
        end
      end
    end
  end
end
