# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

system_user_params = { 
  name: 'flickflow',
  username: 'flickflow',
  email: 'hello@flickflow.com',
  password: Rails.application.secrets.system_user_password
}

if User.new(system_user_params).save
  puts 'System user created'
else
  puts 'System user creation failed'
end
