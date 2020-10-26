/// @param Dialog
function dialog_create_entity_event_page(argument0) {

    var dialog = argument0;

    var dw = 720;
    var dh = 672;

    // you can assume that this is valid data because this won't be called otherwise
    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
    var list = Stuff.map.selected_entities;
    var entity = list[| 0];
    var page = entity.object_events[| index];
    var dg = dialog_create(dw, dh, "Event Page: " + page.name, dialog_default, dc_close_no_questions_asked, dialog);

    dg.page = page;

    var columns = 2;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var c2 = dw / columns;

    var vx1 = dw / (columns * 2) - 32;
    var vy1 = 0;
    var vx2 = vx1 + dw / (columns * 2);
    var vy2 = eh;

    var yy = 64;
    var ucheck_width = 64;        // unlabeled check boxes shouldn't have as wide of a hitbox

    var el_name = create_input(16, yy, "Name:", ew, eh, uivc_entity_event_name, page.name, "Name of the event", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1 - 64, vy1, vx2, vy2, dg);
    yy += eh + spacing;
    var el_enabled = create_checkbox(16, yy, "Enabled", ew, eh, uivc_entity_event_enable, page.enabled, dg);
    yy += eh + spacing;
    var el_condition = create_text(16, yy, "Conditions", ew, eh, fa_left, ew, dg);
    yy += eh + spacing;

    var el_condition_switch_global_enabled = create_checkbox(16, yy, "", ucheck_width, eh, uivc_entity_event_enable_switch_global, page.condition_switch_global_enabled, dg);
    var el_condition_switch_global = create_button(16 + 64, yy, "Global Switch", ew - 64, eh, fa_center, omu_event_condition_attain_switch_data, dg);
    yy += eh + spacing;
    // variable properties go in the form that pops up when you click the button
    var el_condition_variable_global_enabled = create_checkbox(16, yy, "", ucheck_width, eh, uivc_entity_event_enable_variable_global, page.condition_variable_global_enabled, dg);
    var el_condition_variable_global = create_button(16 + 64, yy, "Global Variable", ew - 64, eh, fa_center, omu_event_condition_attain_variable_data, dg);
    yy += eh + spacing;

    var el_condition_switch_self_enabled = create_checkbox(16, yy, "", ucheck_width, eh, uivc_entity_event_enable_switch_self, page.condition_switch_self_enabled, dg);
    var el_condition_switch_self = create_button(16 + 64, yy, "Self Switch", ew - 64, eh, fa_center, omu_event_condition_attain_switch_self_data, dg);
    yy += eh + spacing;
    // variable properties go in the form that pops up when you click the button
    var el_condition_variable_self_enabled = create_checkbox(16, yy, "", ucheck_width, eh, uivc_entity_event_enable_variable_self, page.condition_variable_self_enabled, dg);
    var el_condition_variable_self = create_button(16 + 64, yy, "Self Variable", ew - 64, eh, fa_center, omu_event_condition_attain_variable_self_data, dg);
    yy += eh + spacing;

    vx1 = dw / (columns * 2) - 96;
    vy1 = 0;
    vx2 = vx1 + dw / (columns * 2);
    vy2 = vy1 + eh;

    var el_condition_code_enabled = create_checkbox(16, yy, "", ucheck_width, eh, uivc_entity_event_enable_code, page.condition_code_enabled, dg);
    //var el_condition_code = create_button(16 + 64, yy, "Code Evaluation", ew - 64, eh, fa_center, null, dg);
    var el_condition_code = create_input_code(16 + 64, yy, "Code", ew - 64, eh, vx1, vy1, vx2, vy2, page.condition_code, uivc_event_condition_code, dg);
    yy += el_condition_code.height + spacing + 80;

    var el_condition_explanation = create_text(16, yy,
        "If no conditions are selected, the event will always execute when triggered.\n\nIf more than one are selected, " +
        "the event will only execute when all of the conditions are met.", ew, eh, fa_left, ew, dg
    );

    yy += el_condition_explanation.height + spacing;

    var yy = 64;
    
    var el_trigger = create_list(c2 + 16, yy, "Trigger Method(s)", "<please define some>", ew, eh, 8, uivc_entity_event_trigger_method, true, dg, Stuff.all_event_triggers);
    el_trigger.select_toggle = true;
    dg.el_trigger = el_trigger;
    
    for (var i = 0; i < ds_list_size(Stuff.all_event_triggers); i++) {
        if (page.trigger & (1 << i)) {
            ui_list_select(el_trigger, i);
        }
    }

    yy += ui_get_list_height(el_trigger) + spacing;

    var page_entrypoint = guid_get(page.event_entrypoint);
    if (page_entrypoint) {
        var text_event = page_entrypoint.event.name + " / " + page_entrypoint.name;
    } else{
        var text_event = "<not set>";
    }

    var el_event_text = create_text(c2 + 16, yy, "Event and Entrypoint", ew, eh, fa_left, ew, dg);
    el_event_text.color = c_blue;
    yy += eh + spacing;
    var el_event = create_button(c2 + 16, yy, text_event, ew, eh * 2, fa_left, omu_entity_get_event, dg);
    dg.el_event = el_event;
    yy += el_event.height + spacing;

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

    ds_list_add(dg.contents,
        el_name,
        el_enabled,
        el_condition,
        el_condition_switch_global_enabled,
        el_condition_switch_global,
        el_condition_variable_global_enabled,
        el_condition_variable_global,
        el_condition_switch_self_enabled,
        el_condition_switch_self,
        el_condition_variable_self_enabled,
        el_condition_variable_self,
        el_condition_code_enabled,
        el_condition_code,
        el_condition_explanation,
        el_trigger,
        el_event_text,
        el_event,
        el_confirm
    );

    return dg;


}
