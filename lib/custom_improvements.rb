module CustomImprovements

  require_dependency 'hooks/status/hooks'
  def save_settings
    path = Dir.pwd + '/plugins/custom_improvements/config/settings.yml'
    settings = YAML.load(File.open(path))
    data = CustomImprovements.load_settings
    if data.values != settings.values
      data.each_key { |key| settings[key.to_s] = data[key] }
      File.write(path, settings.to_yaml)
    end
  end

  class << self

    def load_settings(plugin_id = 'custom_improvements')
      cached_settings_name = '@load_settings_' + plugin_id
      cached_settings = instance_variable_get(cached_settings_name)
      if cached_settings.nil?
        data = YAML.safe_load(ERB.new(IO.read(Rails.root.join('plugins',
                                                              plugin_id,
                                                              'config',
                                                              'settings.yml'))).result) || {}
        instance_variable_set(cached_settings_name, data.symbolize_keys)
      else
        cached_settings
      end
    end

    def options_select_custom_fields
      CustomField.all.map { |item| [item.name, item.id] }
    end

    def options_select_tracker
      Tracker.all.map { |item| [item.name, item.id] }
    end

  end
end

