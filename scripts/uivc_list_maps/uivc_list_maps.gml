/// @param UIList

var list = argument0;

var selection = ui_list_selection(list);

if (selection + 1) {
    var what = list.entries[| selection];
    list.root.el_name.interactive = true;
    ui_input_set_value(list.root.el_name, what.name);
    list.root.el_internal_name.interactive = true;
    ui_input_set_value(list.root.el_internal_name, what.internal_name);
    list.root.el_summary.interactive = true;
    ui_input_set_value(list.root.el_summary, what.summary);
    list.root.el_dim_x.interactive = (what == Stuff.map.active_map);
    ui_input_set_value(list.root.el_dim_x, string(what.xx));
    list.root.el_dim_y.interactive = (what == Stuff.map.active_map);
    ui_input_set_value(list.root.el_dim_y, string(what.yy));
    list.root.el_dim_z.interactive = (what == Stuff.map.active_map);
    ui_input_set_value(list.root.el_dim_z, string(what.zz));
    list.root.el_other.interactive = true;
    list.root.el_3d.value = what.is_3d;
    list.root.el_3d.interactive = true;
} else {
    list.root.el_name.interactive = false;
    list.root.el_internal_name.interactive = false;
    list.root.el_summary.interactive = false;
    list.root.el_dim_x.interactive = false;
    list.root.el_dim_y.interactive = false;
    list.root.el_dim_z.interactive = false;
    list.root.el_other.interactive = false;
    list.root.el_3d.interactive = false;
}