/// @param Entity
/// @param solid?

var entity = argument0;
var am_solid = argument1;

var state = entity.static;
entity.static = am_solid;

if (state != am_solid) {
    if (am_solid) {
        ActiveMap.population_static++;
    } else {
        ActiveMap.population_static--;
    }
}