require_dependency 'custom_improvements'
Redmine::Plugin.register :custom_improvements do
  name 'SunStrike Redmine Custom Improvements'
  author 'Pecherskyi Alexei'
  description 'Plugin is developed to simplify user interaction.'
  version '0.2.6'
  url 'http://sunstrikestudios.com'
  # author_url 'http://example.com/about'
  #
  #constants
  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]
  # improvements_disable_on_tracker: 0,
  #     improvements_disable_id_tracker: 0, improvements_disable_project_add_task: 0
  default_settings = CustomImprovements.load_settings

  # settings default: {params: default_settings}, partial: 'improvements/settings/custom_improvements'
  settings default: {'improvements_disable_overrun' => '1','improvements_disable_status' => '1', 'improvements_disable_finish' => '1', 'improvements_disable_date' => '0', 'improvements_disable_on_tracker' => '0', 'improvements_disable_id_tracker' => '0'}, partial: 'improvements/settings/custom_improvements'
  object_to_prepare = Rails.configuration

  #patchs connection
  #
  tor = 'time_task_overrun'
  st = 'status'
  tf = 'task_finish'
  path = './lib/patches'
  object_to_prepare.to_prepare do
    require_relative "#{path}/#{tor}/query_patch.rb"
    require_relative "#{path}/#{tor}/queries_helper_patch.rb"
    require_relative "#{path}/#{st}/time_entries_patch.rb"
    require_relative "#{path}/#{st}/issues_controller_patch.rb"
    require_relative "#{path}/#{tf}/time_entry_patch.rb"
    Query.send(:include, TimeTaskOverrun::Patches::QueryPatch)
    QueriesHelper.send(:include, TimeTaskOverrun::Patches::QueriesHelperPatch)
    TimelogController.send(:include, Status::Patches::TimelogControllerPatch)
    IssuesController.send(:include, Status::Patches::IssuesControllerPatch)
    TimeEntry.send(:include, TaskFinish::Patches::TimeEntryPatch)
  end

end
