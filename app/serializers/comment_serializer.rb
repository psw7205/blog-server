class CommentSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  set_id :id
  set_type :comment

  attributes :body, :commentable_id, :commentable_type

  attribute :created_date do |obj|
    obj.created_at.to_i
  end
  attribute :updated_date do |obj|
    obj.updated_at.to_i
  end

  belongs_to :user, key: :author
end
