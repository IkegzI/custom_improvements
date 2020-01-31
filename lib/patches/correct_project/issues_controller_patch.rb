require_dependency 'issues_controller'
module CorrectProject
  module Patches
    module CorrectProjectPatch

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
            id_field = ProjectCustomField.find_by(name: "Запрещать создание тикетов").id
            field = @project.custom_values.find_by(custom_field_id: id_field).value
            if field == '1'
              @issue.errors.add :base, :permission_project
              redirect_to project_issues_path
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

