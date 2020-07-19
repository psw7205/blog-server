module Blog
  module V1
    class Comments < Grape::API
      include Blog::V1::Authenticate

      resource :comments do
        desc 'Return list of comments'
        params do
          requires :target_type, type: String
          requires :target_id, type: Integer

          optional :page, type: Integer
          optional :total, type: Integer
        end

        get do
          page = params[:page] || 1
          total = params[:total] || 20

          options = {}
          options[:meta] = { total: total, page: page }

          CommentSerializer.new(Comment.page(page).per(total), options)
        end

        desc 'Register comment and return comment object' do
          headers Blog::V1::Authenticate.auth_headers
        end

        params do
          requires :comment, type: Hash do
            requires :target_type, type: String
            requires :target_id, type: Integer

            requires :body, desc: 'comment body'
          end
        end

        post do
          authenticate!
          comment = Comment.create(params[:comment].merge(user_id: current_user.id))
          CommentSerializer.new(comment)
        end

        route_param :id do
          desc 'Return comment info'
          get do
            CommentSerializer.new(Comment.find(params[:id]))
          end

          desc 'Update comment' do
            headers Blog::V1::Authenticate.auth_headers
          end

          params do
            requires :comment, type: Hash do
              optional :body, desc: 'comment body'
            end
          end

          patch do
            authenticate!

            comment = Comment.find(params[:id])
            if current_user.author? comment
              comment.update(params[:comment])
              CommentSerializer.new(comment)
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end

          desc 'Update comment' do
            headers Blog::V1::Authenticate.auth_headers
          end
          params do
            requires :comment, type: Hash do
              requires :body, desc: 'comment body'
            end
          end
          put do
            authenticate!

            comment = Comment.find(params[:id])
            if current_user.author? comment
              comment.update(params[:comment])
              CommentSerializer.new(comment)
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end

          desc 'Delete comment' do
            headers Blog::V1::Authenticate.auth_headers
          end
          delete do
            authenticate!

            comment = Comment.find(params[:id])
            if current_user.author? comment
              comment.destroy
              { message: 'destroy comment' }
            else
              error!(error_message(401, 'Unauthorized'), :unauthorized)
            end
          end
        end
      end
    end
  end
end
