#добавляем хелпер для правильного определения настроек Запрета создания тасков в проекте
module CustomImprovements
  module Patches
    module ProjectsControllerPatch

      include Redmine::I18n

      def self.included(base)
        base.class_eval do
          helper :task_off
        end
      end
    end
  end
end