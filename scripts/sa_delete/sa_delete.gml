if (Stuff.map.selected_zone) {
    instance_activate_object(Stuff.map.selected_zone);
    instance_destroy(Stuff.map.selected_zone);
}

sa_foreach_all(safa_delete, noone);
selection_update_autotiles();
selection_clear();