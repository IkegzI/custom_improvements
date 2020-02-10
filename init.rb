Redmine::Plugin.register :custom_improvements do
  name 'SunStrike Redmine Custom Improvements'
  author 'Pecherskyi Alexei'
  description 'Plugin is developed to simplify user interaction.'
  version '0.2.6'
  url 'http://sunstrikestudios.com'
  require_dependency 'custom_improvements'

  #constants
  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]

  settings default: {'improvements_disable_overrun' => '1','improvements_disable_status' => '1', 'improvements_disable_finish' => '1', 'improvements_disable_date' => '0', 'improvements_disable_on_tracker' => '0', 'improvements_disable_id_tracker' => '0'}, partial: 'improvements/settings/custom_improvements'

end

ActionDispatch::Callbacks.to_prepare do
  Query.send(:include, CustomImprovements::Patches::QueryPatch)
  QueriesHelper.send(:include, CustomImprovements::Patches::QueriesHelperPatch)
  TimeEntry.send(:include, CustomImprovements::Patches::TimeEntryPatch)
end