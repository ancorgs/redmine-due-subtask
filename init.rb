require 'redmine'

Rails.configuration.to_prepare do
  unless Issue.included_modules.include?(DueSubtaskIssuePatch)
      Issue.send(:include, DueSubtaskIssuePatch)
  end
end

Redmine::Plugin.register :due_subtask do
  name 'Due subtask custom field'
  author 'Ancor Gonzalez Sosa'
  description 'Enable the usage of a custom field in issues to automatically calculate the next important date according to due time and subtasks'
  version '0.0.1'
  url 'https://github.com/openSUSE-Team/redmine-due-subtask'
  author_url 'https://github.com/ancorgs'
  requires_redmine :version_or_higher => '2.0.0'
end
