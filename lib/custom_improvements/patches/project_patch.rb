#добавляем хелпер для правильного определения настроек Запрета создания тасков в проекте
module CustomImprovements
  module Patches
    module ProjectPatch

      include Redmine::I18n

      def self.included(base)
        # base.send(:include, InstanceMethods)
        base.class_eval do
          #Для отображения только открытых проектов
          scope :visible_open, lambda {|*args| where('status = 1', Project.visible_condition(args.shift || User.current , *args)) }
        end
      end
    end
  end
end