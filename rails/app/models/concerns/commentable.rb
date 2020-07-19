module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :received_comments, as: :target, class_name: 'Comment' ,dependent: :destroy
  end
end
