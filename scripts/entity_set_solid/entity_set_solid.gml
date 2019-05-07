/// @description  boolean entity_set_solid(Entity, solid?);
/// @param Entity
/// @param  solid?

var state=argument0.am_solid;
argument0.am_solid=argument1;

if (state!=argument1){
    if (argument1){
        ActiveMap.population_solid++;
    } else {
        ActiveMap.population_solid--;
    }
}
