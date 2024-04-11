module Public::UsersHelper
  def helper_user_nav_class(link)
    if action_name.to_s == link
      "nav-link active"
    else
      "nav-link"
    end
  end
end
