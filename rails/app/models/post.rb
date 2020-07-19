class Post < ApplicationRecord
  include Commentable

  before_create :set_email

  belongs_to :user, optional: true
  has_many :comments, dependent: :nullify

  default_scope -> { order('created_at DESC') }

  def set_email
    self.email = user.email
  end
end
