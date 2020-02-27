require_dependency 'time_entry'
module CustomImprovements
  module Patches
    module TimeEntryPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.class_eval do
          validate :ci_time_entry, on: [:create, :update]
        end
      end

      #add columns run_time and total spend hours
      def ci_time_entry

        def valide_time_entry_chande_status
          # if Setting.plugin_custom_improvements['improvements_disable_status'] == '0'
          #   if Issue.find(issue).status_id == 1 and issue.status_id == 1
          # issue.update(status_id: 2)
          # issue.update(status_id: IssueStatus.find(2))
          #   end
          # end
        end

        def errors_add_spent_on?(arg, setting)
          if Setting.plugin_custom_improvements[setting] == '0'
            i = 0
            date = arg
            date_now = Date.strptime(Time.now.strftime('%Y-%m-%d'), '%Y-%m-%d')
            return true if date > date_now
          end
          false
        end

        def errors_add_issue_is_fihish?(arg, setting)
          if Setting.plugin_custom_improvements[setting] == '0'
            begin
              if arg.status_id == 3
                return true
              end
            rescue
              errors.add :base
            end
          end
          false
        end

        def errors_add_issue_on_tracker?(hours, arg, setting)
          check = false
          field_value = nil
          field_id = Setting.plugin_custom_improvements['improvements_disable_id_custom_fields_check'].to_i
          issue.custom_field_values.each do |item|
            if field_id == item.custom_field.id
              field_value = item.value
            end
          end
          binding.pry
          if arg.status_id < 5
            if Setting.plugin_custom_improvements[setting] == '0'
              if (TrackerCheck.where(tracker_id: arg.tracker_id).size > 0 and field_value == '1') or field_value == '1'
                  check = true if arg.estimated_hours.to_f.round(2) < arg.spent_hours.to_f.round(2) + hours.to_f.round(2)
                end
              end
            end
          check
        end

        #нельзя вносить больше, чем в estimate
        errors.add :base, :on_tracker if errors_add_issue_on_tracker?(hours, issue, 'improvements_disable_on_tracker')
        errors.add :issue_id, :is_finish if errors_add_issue_is_fihish?(issue, 'improvements_disable_finish')
        errors.add :spent_on, :date_arrived if errors_add_spent_on?(spent_on, 'improvements_disable_date')
        #автосмена статуса
        # valide_time_entry_chande_status if errors.messages.size == 0
      end
    end
  end
end

# errors.add :base, :on_time_entry if errors_add_on_time_entry(hours, 'improvements_disable_overrun')