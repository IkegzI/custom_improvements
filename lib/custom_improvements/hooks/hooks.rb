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
        end
        
        if Setting.plugin_custom_improvements['improvements_disable_status'] == '0'
          if data[:time_entry]
            if data[:time_entry].validate
              if data[:issue].status_id == 1
                data[:issue].status_id = 2
              end
            end
          end
        end

      end

      def controller_issues_new_before_save(data = {})
        controller_issues_before_save_dry(data)
      end

      def controller_issues_edit_before_save(data = {})
        controller_issues_before_save_dry(data)
      end

      def controller_timelog_edit_before_save(data = {})
        data[:time_entry].hours = data[:time_entry].hours.round(2)

        if Setting.plugin_custom_improvements['improvements_disable_status'] == '0'
          if data[:time_entry]
            if data[:time_entry].validate
              if data[:time_entry].issue.status_id == 1
                binding.pry
                data[:time_entry].issue.update(status_id: 2)
              end
            end
          end
        end

      end

    end
  end
end