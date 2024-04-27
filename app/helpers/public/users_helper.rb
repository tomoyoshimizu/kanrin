module Public::UsersHelper
  def helper_nav_link_class(link)
    if link.eql?(action_name)
      "nav-link nav-link-tab bg-light text-secondary py-3 active disabled font-weight-bold"
    else
      "nav-link nav-link-tab bg-light text-secondary py-3"
    end
  end
end
