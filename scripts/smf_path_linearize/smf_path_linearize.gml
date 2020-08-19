/// @smf_path_linearize(index, steps)
/// @param index
function smf_path_linearize(argument0, argument1) {
    var a, b, c, A, B, C, _x, _y, _z;
    var pthIndex = argument0;
    var pth = SMF_pathList[| pthIndex];
    var steps = max(1, argument1);
    var stepSize = 1 / steps;
    var closed = smf_path_get_closed(pthIndex);
    var pathNum = smf_path_get_number(pthIndex);
    if pathNum == 0{exit;}
    var pathLength = 0;
    var tempPath = ds_list_create();

    //First loop through the path and create a bunch of new path points
    for (var i = 0; i < pathNum; i += stepSize)
    {
        var ii = floor(i);
        b = (ii + pathNum) mod pathNum;
        if closed
        {
            a = (ii - 1 + pathNum) mod pathNum;
            c = (ii + 1 + pathNum) mod pathNum;
        }
        else
        {
            a = max(ii - 1, 0);
            c = min(ii + 1, pathNum - 1);
        }
        A = smf_path_get_point(pthIndex, a);
        B = smf_path_get_point(pthIndex, b);
        C = smf_path_get_point(pthIndex, c);
        for (var j = 0; j < 16; j ++)
        {
            interpolatedMatrix[j] = smf_quadratic_bezier(A[j], B[j], C[j], frac(i));
        }
        ds_list_add(tempPath, interpolatedMatrix);
        if i > 0
        {
            pathLength += point_distance_3d(prevMatrix[SMF_X], prevMatrix[SMF_Y], prevMatrix[SMF_Z], interpolatedMatrix[SMF_X], interpolatedMatrix[SMF_Y], interpolatedMatrix[SMF_Z]);
        }
        prevMatrix = interpolatedMatrix;
        interpolatedMatrix = -1;
    }

    //Then loop through the path again, but this time making sure each point is evenly distanced from the previous point
    ds_list_clear(pth);
    pathNum = ds_list_size(tempPath);
    stepSize = 1;
    var stepLength = pathLength / pathNum;
    var dist = 0;
    for (var i = 0; i < pathNum; i += stepSize)
    {
        var ii = floor(i);
        b = (ii + pathNum) mod pathNum;
        if closed
        {
            a = (ii - 1 + pathNum) mod pathNum;
            c = (ii + 1 + pathNum) mod pathNum;
        }
        else
        {
            a = max(ii - 1, 0);
            c = min(ii + 1, pathNum - 1);
            if ii == pathNum{break;}
        }
        A = smf_path_get_point(pthIndex, a);
        B = smf_path_get_point(pthIndex, b);
        C = smf_path_get_point(pthIndex, c);
        for (var j = 0; j < 16; j ++)
        {
            interpolatedMatrix[j] = smf_quadratic_bezier(A[j], B[j], C[j], frac(i));
        }
        if i > 0
        {
            dist = point_distance_3d(prevMatrix[SMF_X], prevMatrix[SMF_Y], prevMatrix[SMF_Z], interpolatedMatrix[SMF_X], interpolatedMatrix[SMF_Y], interpolatedMatrix[SMF_Z]);
            ratio = stepLength / dist;
            if ratio < 0.999 or  ratio > 1.001
            {
                i -= stepSize;
                stepSize *= ratio;
                continue;
            }
        }
        stepSize = 1;
        smf_path_add_point(pth, interpolatedMatrix[j]);
        prevMatrix = interpolatedMatrix;
        interpolatedMatrix = -1;
    }


}
