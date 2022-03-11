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