module CustomImprovements
  require_dependency 'custom_improvements/hooks/hooks'

  path = './custom_improvements/patches/'
  require_relative "#{path}/project_patch.rb"
  require_relative "#{path}/query_patch.rb"
  require_relative "#{path}/queries_helper_patch.rb"
  require_relative "#{path}/queries_controller_patch.rb"
  require_relative "#{path}/time_entry_patch.rb"
  require_relative "#{path}/issue_patch.rb"
  require_relative "#{path}/issues_controller_patch.rb"
  require_relative "#{path}/settings_controller_patch.rb"
  require_relative "../app/helpers/custom_improvements_helper.rb"


  class << self

    def options_select_custom_fields
      CustomField.all.map { |item| [item.name, item.id] }
    end

    def options_select_tracker
      Tracker.all.map { |item| [item.name, item.id] } - list_add_tracker
    end

    def list_add_tracker
      TrackerCheck.all.map { |item| [item.tracker.name, item.tracker_id] }
    end


  end
end