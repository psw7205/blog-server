module Blog
  module V1
    class Posts < Grape::API
      include Blog::V1::Authenticate

      resource :users do
        route_param :user_id do
          params do
            requires :user_id, type: Integer, desc: 'A user ID.'
          end

          resource :posts do
            desc 'Return list of my posts' do
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

              PostSerializer.new(current_user.posts.page(page).per(total), options)
            end
          end
        end
      end

      resource :posts do
        desc 'Return list of posts'
        params do
          optional :page, type: Integer
          optional :total, type: Integer
        end

        get do
          page = params[:page] || 1
          total = params[:total] || 20

          options = {}
          options[:meta] = { total: total, page: page }

          PostSerializer.new(Post.page(page).per(total), options)
        end

        desc 'Register post and return post object' do
          headers Blog::V1::Authenticate.auth_headers
        end

        params do
          requires :post, type: Hash do
            requires :title, type: String, desc: 'post title'
            requires :body, desc: 'post body'
          end
        end

        post do
          authenticate!
          post = Post.create(params[:post].merge(user_id: current_user.id,
                                                 email: current_user.email))
          PostSerializer.new(post)
        end

        route_param :id do
          desc 'Return post info'
          get do
            PostSerializer.new(Post.find(params[:id]))
          end

          desc 'Update post' do
            headers Blog::V1::Authenticate.auth_headers
          end
          params do
            requires :post, type: Hash do
              optional :title, type: String, desc: 'post title'
              optional :body, desc: 'post body'
            end
          end
          patch do
            authenticate!

            post = Post.find(params[:id])
            if current_user.post? post
              post.update(params[:post])
              PostSerializer.new(post)
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end

          desc 'Update post' do
            headers Blog::V1::Authenticate.auth_headers
          end
          params do
            requires :post, type: Hash do
              requires :title, type: String, desc: 'post title'
              requires :body, desc: 'post body'
            end
          end
          put do
            authenticate!

            post = Post.find(params[:id])
            if current_user.post? post
              post.update(params[:post])
              PostSerializer.new(post)
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end

          desc 'Delete post' do
            headers Blog::V1::Authenticate.auth_headers
          end
          delete do
            authenticate!

            post = Post.find(params[:id])
            if current_user.post? post
              post.destroy
              { message: 'destroy post' }
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end
        end
      end
    end
  end
end
