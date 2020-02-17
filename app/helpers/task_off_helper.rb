module TaskOffHelper

  def check_add_task_off?
    check = false
    cf_id = Setting.plugin_custom_improvements['improvements_field_id_taboo_task'].to_i
    if @project
      @project.custom_field_values.each do |item|
        if item.custom_field.id == cf_id
          check = true if item.value == '1'
        end
      end
    end
    check
  end

  def custom_check_box_project_create
    binding.pry
    unless CustomField.where(type: 'ProjectCustomField').find_by(name: 'Запрещать создание тикетов')
      cf = CustomField.create(
          type: "ProjectCustomField",
          name: "Запрещать создание тикетов",
          field_format: "bool",
          possible_values: nil,
          regexp: "",
          min_length: nil,
          max_length: nil,
          is_required: true,
          is_for_all: false,
          is_filter: false,
          position: 1,
          searchable: false,
          default_value: "1",
          editable: true,
          visible: true,
          multiple: false,
          format_store: {
              "url_pattern" => "",
              "edit_tag_style" => ""
          },
          description: "")
      # Setting.plugin_custom_improvements['improvements_field_id_taboo_task'] = a.id.to_s
    end

    cf_id = Setting.plugin_custom_improvements['improvements_field_id_taboo_task'].to_i
    if cf_id > 0
      cf = CustomField.find(cf_id)
    else
      cf = cf || CustomField.find_by(name: 'Запрещать создание тикетов')
    end

    begin

      if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '1'
        cf.update(is_required: false, visible: false)
      end

      if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '0'
        cf.update(is_required: true, visible: true)

      end

    rescue
      puts 'Error: Field is not access!'
    end
    cf.id || 0
  end


  def check_project_level
    check = false
    projects = []
    project = Project.find_by(identifier: params['parent_id'])
    begin
      projects << project.parent
    rescue
      puts "Error: Parrent dos't exist! "
    end
    if projects.compact.size > 0
      check = true
    end
    check
  end

  def check_issue_select_project(value)
    check = false
    projects = []
    project = Project.find(value.to_i)
    begin
      projects << project.parent
    rescue
      puts "Error: Parrent dos't exist! "
    end
    if projects.compact.size > 0
      check = true
    end
    check
  end

end