/// @param Entity
/// @param solid?

var entity = argument0;
var am_solid = argument1;

var state = entity.static;
entity.static = am_solid;

if (state != am_solid) {
	Stuff.active_map.contents.population_static = Stuff.active_map.contents.population_static + am_solid ? 1 : -1;
}