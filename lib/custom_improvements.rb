module CustomImprovements

  # require_dependency 'improvements/hooks'

  def save_settings
    path = Dir.pwd + '/plugins/custom_improvements/config/settings.yml'
    settings = YAML.load(File.open(path))
    settings["improvements_disable_overrun"] = CustomImprovements.load_settings[:improvements_disable_overrun].to_i
    settings["improvements_disable_status"] = CustomImprovements.load_settings[:improvements_disable_status].to_i
    File.write(path, settings.to_yaml)
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
  end
end

