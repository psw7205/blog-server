class PostSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :id
  set_type :post
  attributes :title, :email, :body
  attribute :created_date do |obj|
    obj.created_at.to_i
  end
  attribute :updated_date do |obj|
    obj.updated_at.to_i
  end

  belongs_to :user, key: :author
end
