/// @param UIThing

var list = Camera.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.offsettable) {        
        thing.off_xx=clamp(real(argument0.value), argument0.value_lower, argument0.value_upper);
        thing.modification=Modifications.UPDATE;
        ds_list_add(Camera.changes, thing);
    }
}