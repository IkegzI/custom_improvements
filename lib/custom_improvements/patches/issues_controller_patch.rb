#добавляем хелпер для правильного определения настроек Запрета создания тасков в проекте

module CustomImprovements
  module Patches
    module IssuesControllerPatch

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
