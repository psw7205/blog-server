class User < ApplicationRecord
  include Commentable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify


  def author?(object)
    return false unless object.user.is_a? User
    return false unless object.user_id == id

    true
  end
end
