require_dependency 'time_entry'
module CustomImprovements
  module Patches
    module TimeEntryPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.class_eval do
          unloadable

          validate :ci_time_entry, on: [:create, :update]
        end
      end

      #add columns run_time and total spend hours
      def ci_time_entry

        def valide_time_entry_chande_status
          if Setting.plugin_custom_improvements['improvements_disable_finish'] == '0'
            if Issue.find(issue).status_id == 1 and issue.status_id == 1
              issue.update(status: IssueStatus.find(2))
              # issue.save validate: false
            end
          end
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
          if Setting.plugin_custom_improvements[setting] == '0'
            if arg.tracker_id == Setting.plugin_custom_improvements['improvements_disable_id_tracker'].to_i
              return true if arg.estimated_hours.to_i < arg.spent_hours.to_i + hours.to_i
            end
          end
          false
        end

        #нельзя вносить больше, чем в estimate
        errors.add :base, :on_tracker if errors_add_issue_on_tracker?(hours, issue, 'improvements_disable_on_tracker')
        errors.add :issue_id, :is_finish if errors_add_issue_is_fihish?(issue, 'improvements_disable_finish')
        errors.add :spent_on, :date_arrived if errors_add_spent_on?(spent_on, 'improvements_disable_date')
        #автосмена статуса
        valide_time_entry_chande_status if errors.messages.size == 0
      end
    end
  end
end

# errors.add :base, :on_time_entry if errors_add_on_time_entry(hours, 'improvements_disable_overrun')