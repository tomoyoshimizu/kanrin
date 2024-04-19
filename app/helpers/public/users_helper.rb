module Public::UsersHelper
  def helper_nav_link_class(link)
    if action_name.to_s == link
      "nav-link nav-link-tab bg-light text-secondary py-3 active disabled font-weight-bold"
    else
      "nav-link nav-link-tab bg-light text-secondary py-3"
    end
  end
end
