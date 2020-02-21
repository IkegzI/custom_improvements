class CustomImprovementsController < ApplicationController

  # def check_task_add_taboo
  #   field_id = Setting.plugin_custom_improvements['improvements_field_id_off_task'].to_i
  #   custom_f = CustomField.find(field_id)
  #   check = true
  #   if project.custom_field_values.value == Setting.plugin_custom_improvements['improvements_disable_project_add_task'].to_i
  #   end
  # end

  def check_project_add_taboo
    check = false
    cf_id = Setting.plugin_custom_improvements['improvements_field_id_taboo_task']
  end
  
  def id_tracker_add
    TrackerCheck.create(tracker_id: Tracker.find(params[:id]).id)
    redirect_to '/settings/plugin/custom_improvements'
  end

  def id_tracker_destroy
    TrackerCheck.find_by(tracker_id: params[:id].to_i).destroy
    redirect_to '/settings/plugin/custom_improvements'
  end

end
