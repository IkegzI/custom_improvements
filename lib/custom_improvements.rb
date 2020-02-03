module CustomImprovements

  require_dependency 'hooks/status/hooks'
  require_dependency 'setting'

  # def save_settings
  #   path = Dir.pwd + '/plugins/custom_improvements/config/settings.yml'
  #   settings = YAML.load(File.open(path))
  #   data = CustomImprovements.load_settings
  #   if data.values != settings.values
  #     data.each_key { |key| settings[key.to_s] = data[key] }
  #     File.write(path, settings.to_yaml)
  #   end
  # end


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

    def custom_check_box_project_create
      unless ProjectCustomField.find_by(name: 'Запрещать создание тикетов')
        a = ProjectCustomField.create(type: "ProjectCustomField",
                                      name: "Запрещать создание тикетов",
                                      field_format: "bool",
                                      possible_values: nil,
                                      regexp: "",
                                      min_length: nil,
                                      max_length: nil,
                                      is_required: false,
                                      is_for_all: false,
                                      is_filter: false,
                                      position: nil,
                                      searchable: false,
                                      default_value: "1",
                                      editable: true,
                                      visible: true,
                                      multiple: false,
                                      format_store: {"url_pattern" => "", "edit_tag_style" => "check_box"},
                                      description: nil,
                                      formula: nil,
                                      is_computed: false,
                                      is_required: true)
        Setting.plugin_custom_improvements['improvements_field_id_off_task'] = a.id.to_s
      else
        Setting.plugin_custom_improvements['improvements_field_id_off_task'] = ProjectCustomField.find_by(name: 'Запрещать создание тикетов').id.to_s
      end
    end

    def custom_check_box_project_field
      Setting.plugin_custom_improvements['improvements_field_id_off_task']
    end


    def custom_check_box_project_setting_off
      binding.pry
      id_field = ProjectCustomField.find(CustomImprovements.custom_check_box_project_field.to_i)
      if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '1'
        if id_field.id
          attr = {default_value: "0", visible: false, is_required: false}
          ProjectCustomField.update(id_field.id, attr)
        end
      elsif Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '0' && id_field.id
        attr = {default_value: "1", visible: true, is_required: true}
        ProjectCustomField.update(id_field.id, attr)
      end

    end

  end
end

