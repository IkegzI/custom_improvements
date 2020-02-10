module CustomImprovements

  require_dependency 'hooks/hooks'
  # require_dependency 'setting'
  path = './patches'
  require_relative "#{path}/query_patch.rb"
  require_relative "#{path}/queries_helper_patch.rb"
  require_relative "#{path}/time_entry_patch.rb"
  require_relative "../app/helpers/custom_improvements_helper.rb"


  class << self

    # def load_settings(plugin_id = 'custom_improvements')
    #   cached_settings_name = '@load_settings_' + plugin_id
    #   cached_settings = instance_variable_get(cached_settings_name)
    #   if cached_settings.nil?
    #     data = YAML.safe_load(ERB.new(IO.read(Rails.root.join('plugins',
    #                                                           plugin_id,
    #                                                           'config',
    #                                                           'settings.yml'))).result) || {}
    #     instance_variable_set(cached_settings_name, data.symbolize_keys)
    #   else
    #     cached_settings
    #   end
    # end

    def options_select_custom_fields
      CustomField.all.map { |item| [item.name, item.id] }
    end

    def options_select_tracker
      Tracker.all.map { |item| [item.name, item.id] }
    end

  end

end

