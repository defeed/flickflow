module UsersHelper
  def display_name_for user
    user.name || user.username
  end
end
