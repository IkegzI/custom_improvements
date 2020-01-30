require_relative "../../custom_improvements.rb"

module Hooks
  include CustomImprovements
  module Status
    class CustomImprovementsHookListener < Redmine::Hook::ViewListener

      render_on(:view_issues_show_details_bottom, partial: 'improvements/status')
      render_on(:view_projects_form, partial: 'improvements/project')
      render_on(:view_layouts_base_content, partial: 'improvements/settings/setsetting')

    end
  end
end