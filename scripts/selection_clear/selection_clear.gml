for (var i=0; i<ds_list_size(selection); i++){
    instance_activate_object(selection[| i]);
    instance_destroy(selection[| i]);
}

ds_list_clear(selection);
last_selection=noone;

sa_process_selection();
