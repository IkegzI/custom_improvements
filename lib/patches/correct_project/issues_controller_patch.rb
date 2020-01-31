require_dependency 'issues_controller'
module CorrectProject
  module Patches
    module IssuesControllerPatch

      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :new, :new_ext
        end
      end

      module InstanceMethods

        def new_ext

          if Setting.plugin_custom_improvements['improvements_disable_project_add_task'] == '0'
            unless @project.nil?
              id_field = ProjectCustomField.find_by(name: "Запрещать создание тикетов").id
              unless @project.custom_values.find_by(custom_field_id: id_field).value.nil?
                field = @project.custom_values.find_by(custom_field_id: id_field).value
              end
            else
              field = ' '
            end

            if field == '1'
              redirect_to project_issues_path(@project), flash: {error: "Создание новых задач в данном проекте ограничено настройками проекта"}
            else
              respond_to do |format|
                format.html { render :action => 'new', :layout => !request.xhr? }
                format.js
              end

            end
          end
        end

      end
    end
  end
end
