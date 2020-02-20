require_relative "../../custom_improvements.rb"
module Hooks
  include CustomImprovements
  module Status

    class CustomImprovementsHookListener < Redmine::Hook::ViewListener


      render_on(:view_issues_show_details_bottom, partial: 'improvements/status')

      #Запрет добавление задач в проект
      render_on(:view_issues_new_top, partial: 'improvements/task_add_off_list_issues')
      render_on(:view_projects_form, partial: 'improvements/task_add_off_new_project')
      #/Запрет добавление задач в проект

      def controller_issues_before_save_dry(data = {})
        unless data[:issue].estimated_hours.nil?
          data[:issue].estimated_hours = data[:issue].estimated_hours.round(2)
          #data[:issue].save
        end
      end

      def controller_issues_new_before_save(data = {})
        controller_issues_before_save_dry(data)
      end

      def controller_issues_edit_before_save(data = {})
        controller_issues_before_save_dry(data)
      end

    end
  end
end