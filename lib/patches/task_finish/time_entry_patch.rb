require_dependency 'time_entry'
module TaskFinish
  module Patches
    module TimeEntryPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :validate_time_entry, :validate_time_entry_ext
        end
      end

      module InstanceMethods
        #add columns run_time and total spend hours
        def validate_time_entry_ext

          def errors_add_spent_on?(arg, setting)
            if CustomImprovements.load_settings[setting] == 0
              i = 0
              date = arg.to_s.split('-')
              date_now = Time.now.to_s.split('-')
              3.times { |i| date.pop if date[i].to_i > date_now[i].to_i }
              return true if date.size != 3
            end
            false
          end
          binding.pry
          errors.add :issue_id, :is_finish if issue.status_id == 3 and CustomImprovements.load_settings[:improvements_disable_finish] == 0
          errors.add :spent_on, :date_arrived if errors_add_spent_on?(spent_on, :improvements_disable_date)
          errors.add :hours, :invalid if hours && (hours < 0 || hours >= 1000)
          errors.add :project_id, :invalid if project.nil?
          errors.add :issue_id, :invalid if (issue_id && !issue) || (issue && project != issue.project) || @invalid_issue_id
          errors.add :activity_id, :inclusion if activity_id_changed? && project && !project.activities.include?(activity)
        end
      end
    end
  end
end
