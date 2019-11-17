/// @description cleanup actions

if (!dialog_exists()) {
    control_global();
}

script_execute(mode.cleanup, mode);

// dialogs (or other things) to be killed

while (!ds_queue_empty(stuff_to_destroy)) {
    var thing = ds_queue_dequeue(stuff_to_destroy);
    instance_activate_object(thing);
    instance_destroy(thing);
}

gpu_set_state(gpu_base_state);

var ts = get_active_tileset();

if (schedule_rebuild_master_texture) {
    if (sprite_exists(ts.master)) {
        sprite_delete(ts.master);
    }
    ts.master = tileset_create_master(ts);
    schedule_rebuild_master_texture = false;
}

if (schedule_view_master_texture) {
    sprite_save_fixed(ts.master, 0, "master-preview.png");
    ds_stuff_open_local("master-preview.png");
    schedule_view_master_texture = false;
}

if (schedule_view_particle_texture) {
    sprite_save_fixed(Stuff.all_graphic_particle_texture, 0, "particle-preview.png");
    ds_stuff_open_local("particle-preview.png");
    schedule_view_particle_texture = false;
}

if (schedule_view_ui_texture) {
    sprite_save_fixed(Stuff.all_graphic_ui_texture, 0, "ui-preview.png");
    ds_stuff_open_local("ui-preview.png");
    schedule_view_ui_texture = false;
}

if (schedule_save) {
    serialize_save_data();
    schedule_save = false;
}

if (schedule_open) {
    var fn = get_open_filename_ddd();
    if (file_exists(fn)) {
        serialize_load(fn);
    }
    
    schedule_open = false;
}

Controller.mouse_x_previous = mouse_x;
Controller.mouse_y_previous = mouse_y;

/*Resize grids when importing a tileset image of a new size
/*
Search for references to Stuff.selection, since it's no longer there
___________________________________________
############################################################################################
FATAL ERROR in
action number 1
of Draw Event
for object Stuff:

Variable Stuff.selection(100088, -2147483648) not set before reading it.
 at gml_Script_momu_set_starting_position_down (line 5) - if (ds_list_size(self.selection) == 1) {
############################################################################################
--------------------------------------------------------------------------------------------
stack frame is
gml_Script_momu_set_starting_position_down (line 5)
called from - gml_Script_menu_render_element (line 33) -         script_execute(menumenu.onmouseup, menumenu);
called from - gml_Script_menu_render_element (line 76) -             script_execute(thing.render, thing, mx1, my1, mx2, my2);
called from - gml_Script_menu_render (line 64) -             script_execute(thing.render, thing, mx1, my1, mx2, my2);
called from - gml_Script_menu_render_main (line 28) -        script_execute(element.render, element, element.x, element.y);
called from - gml_Script_draw_editor_menu (line 22) - script_execute(Stuff.menu.render, Stuff.menu, 0, yy);
called from - gml_Script_editor_render_map (line 7) -     case view_ribbon: draw_editor_menu(mode, true); break;
called from - gml_Object_Stuff_Draw_0 (line 1) - script_execute(mode.render, mode);*/