module Status
  module Patches
    module IssuesControllerPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :update, :update_ext
        end
      end

      module InstanceMethods
        #add columns run_time and spend hours
        def update_ext

          return unless update_issue_from_params
          @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
          saved = false
          begin
            saved = save_issue_with_child_records
          rescue ActiveRecord::StaleObjectError
            @conflict = true
            if params[:last_journal_id]
              @conflict_journals = @issue.journals_after(params[:last_journal_id]).to_a
              @conflict_journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
            end
          end
          if @time_entry
            if Setting.plugin_custom_improvements['improvements_disable_status'] == '0'
              if @issue.status_id == 1
                @issue.status_id = 2
                @issue.save
              end
            end
            if saved
              render_attachment_warning_if_needed(@issue)
              flash[:notice] = l(:notice_successful_update) unless @issue.current_journal.new_record?

              respond_to do |format|
                format.html { redirect_back_or_default issue_path(@issue, previous_and_next_issue_ids_params) }
                format.api { render_api_ok }
              end
            else
              respond_to do |format|
                format.html { render :action => 'edit' }
                format.api { render_validation_errors(@issue) }
              end
            end
          end
        end
      end
    end
  end
end
