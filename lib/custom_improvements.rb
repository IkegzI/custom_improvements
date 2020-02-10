module CustomImprovements

  require_dependency 'hooks/hooks'
  path = './patches'
  require_relative "#{path}/query_patch.rb"
  require_relative "#{path}/queries_helper_patch.rb"
  require_relative "#{path}/time_entry_patch.rb"
  require_relative "../app/helpers/custom_improvements_helper.rb"


  class << self

    def options_select_custom_fields
      CustomField.all.map { |item| [item.name, item.id] }
    end

    def options_select_tracker
      Tracker.all.map { |item| [item.name, item.id] }
    end

  end

end