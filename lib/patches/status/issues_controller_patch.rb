module Status
  module Patches
    module IssuesControllerPatch
      include Redmine::I18n
      include CustomImprovements

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :update, :update_ext
          alias_method :create, :create_ext
        end
      end

      module InstanceMethods
        #add columns run_time and spend hours
        def update_ext
          if Setting.plugin_custom_improvements['improvements_disable_status'] == '0' and @time_entry
            if @issue.status_id == 1
              @issue.status_id = 2
              @issue.save
            end
          end
          return unless update_issue_from_params
          @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
          @issue.estimated_hours = @issue.estimated_hours.round(2) unless @issue.estimated_hours.nil?
          if @issue.estimated_hours == 0
            flash[:error] = 'Введите оценку трудозатрат более 0.01 часов'
            @issue.estimated_hours = ''
          end
          @issue.save
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

        def create_ext
          unless User.current.allowed_to?(:add_issues, @issue.project, :global => true)
            raise ::Unauthorized
          end

          call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
          @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
          binding.pry
          @issue.estimated_hours = @issue.estimated_hours.round(2) unless @issue.estimated_hours.nil?
          if @issue.estimated_hours == 0
            flash[:error] = 'Введите оценку трудозатрат более 0.01 часов'
            @issue.estimated_hours = ''
          end
          if @issue.save
            call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
            respond_to do |format|
              format.html {
                render_attachment_warning_if_needed(@issue)
                flash[:notice] = l(:notice_issue_successful_create, :id => view_context.link_to("##{@issue.id}", issue_path(@issue), :title => @issue.subject))
                redirect_after_create
              }
              format.api  { render :action => 'show', :status => :created, :location => issue_url(@issue) }
            end
            return
          else
            respond_to do |format|
              format.html {
                if @issue.project.nil?
                  render_error :status => 422
                else
                  render :action => 'new'
                end
              }
              format.api  { render_validation_errors(@issue) }
            end
          end
        end


      end
    end
  end
end
