require 'redmine'
require_dependency 'custom_improvements'
Redmine::Plugin.register :custom_improvements do
  name 'SunStrike Redmine Custom Improvements'
  author 'Pecherskyi Alexei'
  description 'Plugin is developed to simplify user interaction.'
  version '0.2.6'
  url 'http://sunstrikestudios.com'
  # author_url 'http://example.com/about'

  def custom_check_box_project(default_settings)
    unless ProjectCustomField.find_by(name: 'Запрещать создание тикетов')
      a = ProjectCustomField.new(type: "ProjectCustomField",
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
                                 format_store: {"url_pattern"=>"", "edit_tag_style"=>"check_box"},
                                 description: nil,
                                 formula: nil,
                                 is_computed: false,
                                 is_required: true)

      a.save
    end
  end
  if ProjectCustomField.find_by(name: 'Запрещать создание тикетов')
    ProjectCustomField.find_by(name: 'Запрещать создание тикетов').destroy
  end

  #constants
  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]
  # improvements_disable_on_tracker: 0,
  #     improvements_disable_id_tracker: 0, improvements_disable_project_add_task: 0
  default_settings = CustomImprovements.load_settings

  # settings default: {params: default_settings}, partial: 'improvements/settings/custom_improvements'
  settings default: {'improvements_disable_overrun' => '1','improvements_disable_status' => '1', 'improvements_disable_finish' => '1', 'improvements_disable_date' => '0', 'improvements_disable_on_tracker' => '0', 'improvements_disable_id_tracker' => '0', 'improvements_disable_custom_fields_check' => '0', 'improvements_disable_id_custom_fields_check' => '0', 'improvements_disable_wrong_write' => '0', 'improvements_disable_project_add_task' => '1'}, partial: 'improvements/settings/custom_improvements'
  object_to_prepare = Rails.configuration
  # custom_check_box_project(default_settings)

  #patchs connection
  #
  tor = 'time_task_overrun'
  st = 'status'
  tf = 'task_finish'
  cf = 'custom_field_check'
  cp = 'correct_project'
  path = './lib/patches'
  object_to_prepare.to_prepare do
    require_relative "#{path}/#{tor}/query_patch.rb"
    require_relative "#{path}/#{tor}/queries_helper_patch.rb"
    require_relative "#{path}/#{tor}/settings_controller_patch.rb"
    require_relative "#{path}/#{st}/time_entries_patch.rb"
    require_relative "#{path}/#{tf}/time_entry_patch.rb"
    require_relative "#{path}/#{cf}/issue_patch.rb"
    require_relative "#{path}/#{cp}/issues_controller_patch.rb"
    Query.send(:include, TimeTaskOverrun::Patches::QueryPatch)
    QueriesHelper.send(:include, TimeTaskOverrun::Patches::QueriesHelperPatch)
    # SettingsController.send(:include, TimeTaskOverrun::Patches::SettingsControllerPatch)
    TimelogController.send(:include, Status::Patches::TimelogControllerPatch)
    TimeEntry.send(:include, TaskFinish::Patches::TimeEntryPatch)
    Issue.send(:include, CustomFieldCheck::Patches::CustomFieldsPatch)
    #permission_project
    IssuesController.send(:include, CorrectProject::Patches::IssuesControllerPatch)
  end

end
{'improvements_disable_overrun' => '1','improvements_disable_status' => '1', 'improvements_disable_finish' => '1', 'improvements_disable_date' => '0', 'improvements_disable_on_tracker' => '0', 'improvements_disable_id_tracker' => '0', 'improvements_disable_custom_fields_check' => '0', 'improvements_disable_id_custom_fields_check' => '0', 'improvements_disable_wrong_write' => '0', 'improvements_disable_project_add_task' => '1'}