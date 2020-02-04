require_relative "../../custom_improvements.rb"

module Hooks
  include CustomImprovements
  module Status
    class CustomImprovementsHookListener < Redmine::Hook::ViewListener

      render_on(:view_issues_show_details_bottom, partial: 'improvements/status')

    end
  end
end