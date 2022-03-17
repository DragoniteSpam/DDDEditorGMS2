// `f` is a function that runs on each selected entity. It takes two parameters,
// the entity and the `data`.
// 
// `data` is a data blob containing whatever information you might need to
// carry out the operation. For example, if you wanted to rename every selected
// entity, you would call map_foreach_selected with { name: "whatever" } in the
// data parameter.
function map_foreach_selected(f, data) {
    var list = Stuff.map.selected_entities;
    for (var i = 0, n = ds_list_size(list); i < n; i++) {
        f(list[| i], data);
    }
}

function map_selection_like_type(list, type_flag) {
    if (ds_list_size(list) == 0) return false;
    for (var i = 0, n = ds_list_size(list); i < n; i++) {
        if (list[| i].etype & type_flag == 0) return false;
    }
    return true;
}

// Loops through all selected entities; if all entities (of the specified type)
// shae the specified property, return a struct containing the property;
// otherwise, return undefined
function map_selection_like_property(list, property, type_flag = ETypeFlags.ENTITY) {
    var first_value = undefined;
    for (var i = 0, n = ds_list_size(list); i < n; i++) {
        if (list[| i].etype & type_flag == 0) continue;
        if (first_value == undefined) {
            first_value = list[| i][$ property];
        } else {
            if (first_value != list[| i][$ property]) return undefined;
        }
    }
    if (!first_value) return undefined;
    return { value: first_value };
}