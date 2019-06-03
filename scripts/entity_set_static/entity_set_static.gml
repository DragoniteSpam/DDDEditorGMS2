/// @description boolean entity_set_static(Entity, solid?);
/// @param Entity
/// @param solid?

var state=argument0.static;
argument0.static=argument1;

if (state!=argument1) {
    if (argument1) {
        ActiveMap.population_static++;
    } else {
        ActiveMap.population_static--;
    }
}
