require_dependency 'issue'
module CustomImprovements
  module Patches
    module IssuePatch

      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          validate :ci_issue_validate, on: [:create, :update]

        end
      end

      # improvements_disable_custom_fields_check: 0
      # improvements_disable_id_custom_fields_check: 0
      module InstanceMethods


        def ci_issue_validate


#Запрещать создание сдельных задач без эстимейта
          def check_error_field(arg, setting)
            if Setting.plugin_custom_improvements[setting] == '0' and arg.value == '1'
              if arg.custom_field.id == Setting.plugin_custom_improvements['improvements_disable_id_custom_fields_check'].to_i
                return true if estimated_hours.nil? or estimated_hours.to_f <= 0
              end
            end
          end


          if Setting.plugin_custom_improvements['improvements_disable_custom_fields_check'] == '0'
            field_id = Setting.plugin_custom_improvements['improvements_disable_id_custom_fields_check'].to_i
            custom_field_values.each do |item|
              if item.custom_field.id == field_id
                errors.add :base, :error_estimate if check_error_field(item, 'improvements_disable_custom_fields_check')
              end
            end
          end
#/Запрещать создание сдельных задач без эстимейта
#
# Запрещать создание тикетов в данном проекте
          if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '0'

            def check_error_taboo_task

              check = false
              status_field = Setting.plugin_custom_improvements['improvements_disable_project_add_task'].to_i
              check_field_id = Setting.plugin_custom_improvements['improvements_field_id_taboo_task'].to_i
              if status_field == 0
                project.custom_field_values.each do |item|
                  if item.custom_field.id == check_field_id
                    check = true if item.value == '1'
                  end
                end
              end
              check
            end

            errors.add :base, :taboo_task if check_error_taboo_task
          end

# /Запрещать создание тикетов в данном проекте

        end
      end

    end
  end
end
