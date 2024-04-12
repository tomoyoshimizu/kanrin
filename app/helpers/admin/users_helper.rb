module Admin::UsersHelper
  def helper_nav_link_params(is_active)
    result = {}
    result[:search_word] = @search_word if @search_word.present?
    result[:is_active] = is_active if is_active.present?
    result
  end

  def helper_nav_link_class(is_active)
    if is_active == @is_active
      "nav-link active"
    else
      "nav-link"
    end
  end
end
