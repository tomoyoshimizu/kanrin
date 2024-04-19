module Admin::UsersHelper
  def helper_nav_link_params(is_active)
    result = {}
    result[:search_word] = @search_word if @search_word.present?
    result[:is_active] = is_active if is_active.present?
    result
  end

  def helper_nav_link_class(is_active)
    if is_active == @is_active
      "nav-link nav-link-tab bg-light text-secondary py-3 active disabled font-weight-bold"
    else
      "nav-link nav-link-tab bg-light text-secondary py-3"
    end
  end
end
