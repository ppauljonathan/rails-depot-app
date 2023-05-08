namespace :user do
  desc 'set all existing users in the database as admins'

  task :set_as_admin,[:email] => :environment do |t, args|
    user = User.find_by_email(args.email)
    unless user
      puts "User with email '#{args.email}' does not exist"
    else
      user.update!(role: 'admin')
    end
  end
end