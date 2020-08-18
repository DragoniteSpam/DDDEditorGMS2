/// @description spart_emitter_set_sector(ind, sector)
/// @param ind
/// @param sector
function spart_emitter_set_sector(argument0, argument1) {
	/*
		This is a special uniform that only affects circular and cylindrical emitters.
		Limits the sector of the circle or cylinder in which particles can spawn.
	*/
	var partEmitter = argument0;
	partEmitter[| sPartEmt.Sector] = argument1;


}
