module CustomImprovements
  module Patches
    module QueriesControllerPatch
      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :filter, :ci_filter
        end
      end

      #
      module InstanceMethods
        #filter only open project
        def ci_filter
          q = query_class.new
          if params[:project_id].present?

            q.project = Project.find(params[:project_id]).where(status: 1)
          end

          unless User.current.allowed_to?(q.class.view_permission, q.project, :global => true)

            raise Unauthorized
          end

          filter = q.available_filters[params[:name].to_s]
          values = filter ? filter.values : []

          render :json => values
        rescue ActiveRecord::RecordNotFound
          render_404
        end

      end
    end
  end
end