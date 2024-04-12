module Public::UsersHelper
  def helper_nav_link_class(link)
    if action_name.to_s == link
      "nav-link active"
    else
      "nav-link"
    end
  end
end
