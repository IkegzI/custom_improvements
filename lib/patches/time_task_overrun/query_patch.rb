require_dependency 'query'
module TimeTaskOverrun
  module Patches
    module QueryPatch
      include Redmine::I18n
      include CustomImprovements
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :columns, :columns_ext
        end
      end

      module InstanceMethods
        #add columns run_time and spend hours
        def columns_ext
          @savers = @savers || 1
          cols = (has_default_columns? ? default_columns_names : column_names).collect do |name|
            available_columns.find { |col| col.name == name }
          end.compact
          save_settings if @savers == 1
          @savers += 1
          if CustomImprovements.load_settings[:improvements_disable_overrun].to_i == 0
            cols.insert(3, available_columns.find { |col| col.name == :spent_hours })
            cols.insert(3, available_columns.find { |col| col.name == :estimated_hours })
          end
          (available_columns.select(&:frozen?) | cols).compact
        end
      end
    end
  end
end
