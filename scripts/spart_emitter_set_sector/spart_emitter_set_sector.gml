/// @description spart_emitter_set_sector(ind, sector)
/// @param ind
/// @param sector
/*
	This is a special uniform that only affects circular and cylindrical emitters.
	Limits the sector of the circle or cylinder in which particles can spawn.
*/
var partEmitter = argument0;
partEmitter[| sPartEmt.Sector] = argument1;