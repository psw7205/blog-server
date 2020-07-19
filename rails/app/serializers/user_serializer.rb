class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attribute :email
end
