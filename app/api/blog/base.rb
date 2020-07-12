module Blog
  class Base < Grape::API
    mount Blog::V1::Base

    add_swagger_documentation
  end
end
