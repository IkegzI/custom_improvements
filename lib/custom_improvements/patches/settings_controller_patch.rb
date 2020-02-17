#добавляем хелпер для правильного определения настроек Запрета создания тасков в проекте
require_dependency 'settings_controller'
module CustomImprovements
  module Patches
    module SettingsControllerPatch

      include Redmine::I18n

      def self.included(base)
        # base.send(:include, InstanceMethods)
        base.class_eval do
          helper :task_off
        end
      end

    end
  end
end
