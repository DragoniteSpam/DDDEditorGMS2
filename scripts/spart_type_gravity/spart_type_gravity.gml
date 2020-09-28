/// @description spart_type_gravity(partType, grav_amount, xdir, ydir, zdir)
/// @param partType
/// @param grav_amount
/// @param xdir
/// @param ydir
/// @param zdir
function spart_type_gravity(argument0, argument1, argument2, argument3, argument4) {
    /*
        Define the gravity direction and amount (units per second) of the particle

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partType = argument0;
    var amount = argument1;
    var xdir = argument2;
    var ydir = argument3;
    var zdir = argument4;
    var l = amount / point_distance_3d(0, 0, 0, xdir, ydir, zdir);
    partType[| sPartTyp.GravDir] = [xdir * l, ydir * l, zdir * l];



}
