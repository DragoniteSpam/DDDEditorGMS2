/// @param Entity
/// @param solid?

var entity = argument0;
var is_solid = argument1;

var state = entity.am_solid;
entity.am_solid = is_solid;

if (state != is_solid) {
	Stuff.map.active_map.contents.population_solid = Stuff.map.active_map.contents.population_solid + is_solid ? 1 : -1;
}