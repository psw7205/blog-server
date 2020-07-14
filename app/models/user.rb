class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :posts, dependent: :nullify

  def post?(post)
    return false unless post.is_a? Post
    return false unless post.user.is_a? User
    return false unless post.user_id == id

    true
  end
end
