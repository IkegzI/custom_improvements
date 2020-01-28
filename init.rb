require 'redmine'
require_dependency 'custom_improvements'
Redmine::Plugin.register :custom_improvements do
  name 'Custom Improvements plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  default_settings = CustomImprovements.load_settings
  settings(default: default_settings, partial: 'improvements/settings/custom_improvements')


  object_to_prepare = Rails.configuration
  #patchs connection
  tor = 'time_task_overrun'
  st = 'status'
  path = './lib/patches'
  object_to_prepare.to_prepare do
    require_relative "#{path}/#{tor}/query_patch.rb"
    require_relative "#{path}/#{tor}/queries_helper_patch.rb"
    require_relative "#{path}/#{tor}/settings_controller_patch.rb"
    require_relative "#{path}/#{st}/time_entries_patch.rb"
    Query.send(:include, TimeTaskOverrun::Patches::QueryPatch)
    QueriesHelper.send(:include, TimeTaskOverrun::Patches::QueriesHelperPatch)
    SettingsController.send(:include, TimeTaskOverrun::Patches::SettingsControllerPatch)
    TimelogController.send(:include, Status::Patches::TimelogControllerPatch)
    #IssuesController.send(:include, Status::Patches::IssuesControllerPatch)
  end

  menu :admin_menu, :custom_improvements, {controller: 'settings', action: 'plugin', id: 'custom_improvements'}, caption: :label_improvements

end
