require_dependency 'query'
module TimeTaskOverrun
  module Patches
    module SettingsControllerPatch
      include Redmine::I18n
      include CustomImprovements
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :plugin, :plugin_ext
        end
      end

      module InstanceMethods
        #add columns run_time and total spend hours
        def plugin_ext
          @plugin = Redmine::Plugin.find(params[:id])
          unless @plugin.configurable?
            render_404
            return
          end
          if request.post?
            setting = params[:settings] ? params[:settings].permit!.to_h : {}
            if setting['id'] == 'CustomImprovements'
              CustomImprovements.load_settings[:improvements_disable_overrun] = setting['improvements_disable_overrun'].to_i
              CustomImprovements.load_settings[:improvements_disable_status] = setting['improvements_disable_status'].to_i
              CustomImprovements.load_settings[:improvements_disable_finish] = setting['improvements_disable_finish'].to_i
              CustomImprovements.load_settings[:improvements_disable_date] = setting['improvements_disable_date'].to_i
              CustomImprovements.load_settings[:improvements_disable_on_tracker] = setting['improvements_disable_on_tracker'].to_i
              CustomImprovements.load_settings[:improvements_disable_id_tracker] = setting['improvements_disable_id_tracker'].to_i
            end
            Setting.send "plugin_#{@plugin.id}=", setting
            flash[:notice] = l(:notice_successful_update)
            redirect_to plugin_settings_path(@plugin)
          else
            @partial = @plugin.settings[:partial]
            @settings = Setting.send "plugin_#{@plugin.id}"
          end
        rescue Redmine::PluginNotFound
          render_404
        end
      end
    end
  end
end
