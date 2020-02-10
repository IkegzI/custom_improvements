require_dependency 'time_entry'
module CustomImprovements
  module Patches
    module TimeEntryPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          validate :validate_time_entry_ext, on: [:create, :update]
        end
      end

      module InstanceMethods
        #add columns run_time and total spend hours
        def validate_time_entry_ext

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

          errors.add :issue_id, :is_finish if errors_add_issue_is_fihish?(issue, 'improvements_disable_finish')
          errors.add :spent_on, :date_arrived if errors_add_spent_on?(spent_on, 'improvements_disable_date')
        end
      end
    end
  end
end

##on_time_entry > 0.00566666666666669 for print error
# def errors_add_on_time_entry(hours, setting)
#           #   if Setting.plugin_custom_improvements[setting] == '0'
#           #     if hours < 0.00566666666666669
#           #       return true
#           #     end
#           #   end
#           #   false
#           # end
#
#           # errors.add :base, :on_time_entry if errors_add_on_time_entry(hours, 'improvements_disable_overrun')