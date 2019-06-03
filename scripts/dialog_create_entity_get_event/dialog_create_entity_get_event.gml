/// @description void dialog_create_entity_get_event(Dialog);
/// @param Dialog

var dw=320;
var dh=640;

// you can assume that this is valid data because this won't be called otherwise
var index=ui_list_selection(Camera.ui.element_entity_events);
var list=Camera.selected_entities;
var entity=list[| 0];

var page=entity.object_events[| index];
var dg=dialog_create(dw, dh, "Select Event", dialog_default, dc_close_no_questions_asked, argument0);

var columns=1;
var ew=(dw-columns*32)/columns;
var eh=24;

var vx1=dw/(columns*2)-16;
var vy1=0;
var vx2=vx1+dw/(columns*2)-16;
var vy2=vy1+eh;

var yy=64;
var spacing=16;

var el_list=create_list(16, yy, "Select an event", "<should never see this>", ew, eh, 20, null, false, dg);
el_list.render=ui_render_list_event;
el_list.entries_are=ListEntries.INSTANCES;
dg.el_list=el_list;

for (var i=0; i<ds_list_size(Stuff.all_events); i++) {
    if (Stuff.all_events[| i].GUID==page.event_guid) {
        ds_map_add(el_list.selected_entries, i, true);
        break;
    }
}

var b_width=128;
var b_height=32;
var el_confirm=create_button(dw/2-b_width/2, dh-32-b_height/2, "Commit", b_width, b_height, fa_center, dmu_dialog_entity_get_event, dg);

ds_list_add(dg.contents, el_list,
    el_confirm);

keyboard_string="";

return dg;
