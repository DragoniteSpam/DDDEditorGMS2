/// @param UICheckbox

var checkbox = argument0;

// safe
var index = ui_list_selection(Stuff.map.ui.element_entity_events);
var list = Stuff.map.selected_entities
var entity = list[| 0];
var page = entity.object_events[| index];

page.option_direction_fix = checkbox.value;