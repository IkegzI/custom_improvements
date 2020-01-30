require 'redmine'
require_dependency 'custom_improvements'
Redmine::Plugin.register :custom_improvements do
  name 'SunStrike Redmine Custom Improvements'
  author 'Pecherskyi Alexei'
  description 'Plugin is developed to simplify user interaction.'
  version '0.2.6'
  url 'http://sunstrikestudios.com'
  # author_url 'http://example.com/about'

  #constants
  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]

  default_settings = CustomImprovements.load_settings
  settings(default: default_settings, partial: 'improvements/settings/custom_improvements')
  object_to_prepare = Rails.configuration

  #patchs connection
  # 
  tor = 'time_task_overrun'
  st = 'status'
  tf = 'task_finish'
  hl = 'helpers'
  path = './lib/patches'
  object_to_prepare.to_prepare do
    require_relative "#{path}/#{tor}/query_patch.rb"
    require_relative "#{path}/#{tor}/queries_helper_patch.rb"
    require_relative "#{path}/#{tor}/settings_controller_patch.rb"
    require_relative "#{path}/#{st}/time_entries_patch.rb"
    require_relative "#{path}/#{tf}/time_entry_patch.rb"
    Query.send(:include, TimeTaskOverrun::Patches::QueryPatch)
    QueriesHelper.send(:include, TimeTaskOverrun::Patches::QueriesHelperPatch)
    SettingsController.send(:include, TimeTaskOverrun::Patches::SettingsControllerPatch)
    TimelogController.send(:include, Status::Patches::TimelogControllerPatch)
    TimeEntry.send(:include, TaskFinish::Patches::TimeEntryPatch)
    #IssuesController.send(:include, Status::Patches::IssuesControllerPatch)
  end

end
