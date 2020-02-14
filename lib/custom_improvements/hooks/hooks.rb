require_relative "../../custom_improvements.rb"
module Hooks
  include CustomImprovements
  module Status

    class CustomImprovementsHookListener < Redmine::Hook::ViewListener


      render_on(:view_issues_show_details_bottom, partial: 'improvements/status')

      def controller_timelog_edit_before_save(data = {})
        unless data[:time_entry].hours.nil?
          data[:time_entry].hours = data[:time_entry].hours.round(2)
        end
        if Setting.plugin_custom_improvements['improvements_disable_status'] == '0' and data[:time_entry].issue
          if data[:time_entry].issue.status_id == 1
            data[:time_entry].issue.status_id = 2
            data[:time_entry].issue.save
          end
        end
        data[:time_entry].hours
      end

      def controller_issues_before_save_dry(data = {})
        unless data[:issue].estimated_hours.nil?
          data[:issue].estimated_hours = data[:issue].estimated_hours.round(2)
          data[:issue].save
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