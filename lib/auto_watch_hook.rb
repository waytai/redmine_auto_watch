# Hooks to attach to the Redmine Issues.
class AutoWatchHook < Redmine::Hook::Listener
  def controller_issues_edit_before_save(context = {})
    issue = context[:issue]

    add_current_user(issue)
    add_assignee(issue)
  end

  def controller_issues_new_before_save(context = {})
    add_assignee(context[:issue])
  end


  def controller_issues_bulk_edit_before_save(context = {})
    issue = context[:issue]

    add_current_user(issue)
    add_assignee(issue)
  end

  private
  def add_current_user(issue)
    unless issue.watched_by?(User.current) # || issue.author == User.current
      issue.add_watcher(User.current)
    end
  end
    
  def add_assignee(issue)
    assignee = issue.assigned_to
    unless assignee.nil? || !assignee.is_a?(User) || issue.watched_by?(assignee) # || issue.author == issue.assigned_to
      issue.add_watcher(assignee)
    end
  end
end
