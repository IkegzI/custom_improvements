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


end
