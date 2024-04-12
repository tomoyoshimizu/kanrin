module ApplicationHelper
  def helper_project_status_class(status)
    case status
      when "in_progress" then "badge badge-primary"
      when "completed" then "badge badge-secondary"
      when "pending" then "badge badge-warning"
    end
  end
end
