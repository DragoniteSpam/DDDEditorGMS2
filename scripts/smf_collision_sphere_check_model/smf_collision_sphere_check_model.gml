/// @description smf_collision_check_model(modelIndex, x, y, z, radius)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param radius
function smf_collision_sphere_check_model(argument0, argument1, argument2, argument3, argument4) {
    /*
    Returns true if there is a collision

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var i, j, k, n, pos, d, u, tris, addRadius, tempDistance, t, v, dp, returnUp, testPos;

    //Read collision header
    var modelIndex = argument0;
    var colList = modelIndex[| SMF_model.CollisionList];
    var octList = modelIndex[| SMF_model.OctreeList];
    if colList == -1
    {
        return smf__collision_check_buffer(argument0, argument1, argument2, argument3, argument4);
    }

    //Transform player coordinates
    pos = [argument1 - octList[| 1], argument2 - octList[| 2], argument3 - octList[| 3]];
    addRadius = argument4;
    tris = smf__collision_get_region(octList, pos[0], pos[1], pos[2]);
    n = array_length(tris);
    for (i = 0; i < n; i ++)
    {
        //----------------------------------If the object is closer than it's supposed to, push it away from the model and return the new coordinates
        testPos = smf_project_to_triangle(pos, colList[| tris[i]]);
        d = max(abs(pos[0] - testPos[0]), abs(pos[1] - testPos[1]), abs(pos[2] - testPos[2]));
        if d <= addRadius
        {
            return true;
        }
    }
    return false;


}
