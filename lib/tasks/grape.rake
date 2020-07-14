namespace :grape do
  desc 'Print out routes'

  task routes: :environment do
    Blog::Base.routes.each do |route|
      method = route.request_method.ljust(10)
      path = route.path
      puts "#{method} #{path}"
    end
  end
end
