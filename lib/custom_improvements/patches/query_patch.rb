require_dependency 'query'
module CustomImprovements
  module Patches
    module QueryPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :columns, :ci_columns_ext
          #Для отображения только открытых проектов
          alias_method :all_projects, :ci_all_projects
          alias_method :subproject_values, :ci_subproject_filter
        end
      end

      module InstanceMethods
        #add columns run_time and spend hours
        def ci_columns_ext
          cols = (has_default_columns? ? default_columns_names : column_names).collect do |name|
            available_columns.find { |col| col.name == name }
          end.compact

          if Setting.plugin_custom_improvements['improvements_disable_overrun'].to_i == 0
            cols.insert(3, available_columns.find { |col| col.name == :spent_hours })
            cols.insert(3, available_columns.find { |col| col.name == :estimated_hours })
          end
          (available_columns.select(&:frozen?) | cols).compact
        end

#Для отображения только открытых проектов
        def ci_all_projects
          if Setting.plugin_custom_improvements['improvements_disable_filter_open'] == '0'
            @all_projects ||= Project.visible_open.to_a
          else
            @all_projects ||= Project.visible.to_a
          end
        end

        def ci_subproject_filter
          if Setting.plugin_custom_improvements['improvements_disable_filter_open'] == '0'
            project.descendants.visible.where(status: 1).collect { |s| [s.name, s.id.to_s] }
          else
            project.descendants.visible.collect { |s| [s.name, s.id.to_s] }
          end
        end

      end
    end
  end
end
