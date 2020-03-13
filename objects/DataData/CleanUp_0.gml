if (Stuff.is_quitting) exit;

event_inherited();

ds_list_destroy_instances(properties);

if (instances) ds_list_destroy_instances(instances);