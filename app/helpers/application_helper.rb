module ApplicationHelper
  def helper_index_form_url
    case controller_name
    when "tags"     then tags_path
    when "projects" then projects_path
    when "users"    then users_path
    end
  end

  def helper_index_link_params(is_active)
    {search_word: @search_word} if @search_word.present?
  end

  def helper_index_link_class(name)
    if name.eql?(controller_name)
      "nav-link nav-link-tab bg-light text-secondary py-3 active disabled font-weight-bold"
    else
      "nav-link nav-link-tab bg-light text-secondary py-3"
    end
  end

  def helper_project_visibility_class(visibility)
    case visibility
    when "visible" then "badge badge-success"
    when "hidden"  then "badge badge-danger"
    end
  end

  def helper_project_status_class(status)
    case status
    when "in_progress" then "badge badge-primary"
    when "completed"   then "badge badge-secondary"
    when "pending"     then "badge badge-warning"
    end
  end
end
