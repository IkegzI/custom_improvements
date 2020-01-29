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
          errors.add :issue_id, :is_finish if issue.status_id == 3 and CustomImprovements.load_settings[:improvements_disable_finish] == 0
          errors.add :hours, :invalid if hours && (hours < 0 || hours >= 1000)
          errors.add :project_id, :invalid if project.nil?
          errors.add :issue_id, :invalid if (issue_id && !issue) || (issue && project!=issue.project) || @invalid_issue_id
          errors.add :activity_id, :inclusion if activity_id_changed? && project && !project.activities.include?(activity)
        end
      end
    end
  end
end
