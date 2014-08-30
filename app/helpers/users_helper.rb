module UsersHelper
  def display_name_for user
    user.name.blank? ? user.username : user.name
  end
end
