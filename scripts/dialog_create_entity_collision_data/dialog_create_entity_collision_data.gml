/// @param root

var root = argument0;

var dw = 1280;
var dh = 640;

// you can assume that this is valid data because this won't be called otherwise
var index = ui_list_selection(Stuff.map.ui.element_entity_events);
var list = Stuff.map.selected_entities;
var entity = list[| 0];

var dg = dialog_create(dw, dh, "Collision Data: " + entity.name, dialog_default, dc_close_no_questions_asked, root);

dg.entity = entity;

var columns = 4;
var spacing = 16;
var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var c1 = dw * 0 / columns + spacing;
var c2 = dw * 1 / columns + spacing;
var c3 = dw * 2 / columns + spacing;
var c4 = dw * 3 / columns + spacing;

var vx1 = dw / (columns * 2) - 32;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2);
var vy2 = vy1 + eh;

var yy = 64;

var el_collision_flags = create_bitfield(c1, yy, "Collision Flags", ew, eh, null, entity.collision_flags, dg);

for (var i = 0; i < 32; i++) {
    var field_xx = (i >= 16) ? ew : 0;
    // Each element will be positioned based on the one directly above it, so you
    // only need to move them up once otherwise they'll keep moving up the screen
    var field_yy = (i == 16) ? -(eh * 16) : 0;
    create_bitfield_options_vertical(el_collision_flags, [create_bitfield_option_data(i, ui_render_bitfield_option_text_collision, uivc_bitfield_entity_collision, string(i), -1, 0, ew / 2, spacing / 2, field_xx, field_yy)]);
}

create_bitfield_options_vertical(el_collision_flags, [
    create_bitfield_option_data(i, ui_render_bitfield_option_text_collision_all, uivc_bitfield_entity_collision_all, "All", -1, 0, ew / 2, spacing / 2, 0, 0),
    create_bitfield_option_data(i, ui_render_bitfield_option_text_collision_none, uivc_bitfield_entity_collision_none, "None", -1, 0, ew / 2, spacing / 2, ew, -eh),
]);

var el_event_flags = create_bitfield(c3, yy, "Event Flags", ew, eh, null, entity.event_flags, dg);

for (var i = 0; i < 32; i++) {
    var field_xx = (i >= 16) ? ew : 0;
    var field_yy = (i == 16) ? -(eh * 16) : 0;
    create_bitfield_options_vertical(el_event_flags, [create_bitfield_option_data(i, ui_render_bitfield_option_text_event, uivc_bitfield_entity_entity, string(i), -1, 0, ew / 2, spacing / 2, field_xx, field_yy)]);
}

create_bitfield_options_vertical(el_event_flags, [
    create_bitfield_option_data(i, ui_render_bitfield_option_text_event_all, uivc_bitfield_entity_entity_all, "All", -1, 0, ew / 2, spacing / 2, 0, 0),
    create_bitfield_option_data(i, ui_render_bitfield_option_text_event_none, uivc_bitfield_entity_entity_none, "None", -1, 0, ew / 2, spacing / 2, ew, -eh),
]);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_collision_flags,
    el_event_flags,
    el_confirm
);

return dg;