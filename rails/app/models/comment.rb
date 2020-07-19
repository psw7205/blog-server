class Comment < ApplicationRecord
  include Commentable

  belongs_to :user
  belongs_to :target, :polymorphic => true

  default_scope -> { order('created_at DESC') }
end
