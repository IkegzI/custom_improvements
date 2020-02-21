# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
post "/ci/check_project" =>  "custom_improvements#check_task_add_taboo"
post "/id_tracker/add/:id" =>  "custom_improvements#id_tracker_add"
post "/id_tracker/destroy/:id" =>  "custom_improvements#id_tracker_destroy"