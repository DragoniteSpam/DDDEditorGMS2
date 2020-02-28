/// @param x
/// @param y
/// @param z
/// @param viewMat
/// @param projMat
/// @param width
/// @param height
/*
    Transforms a 3D world-space coordinate to a 2D window-space coordinate. Returns an array of the following format:
    [x, y]
    Returns [-1, -1] if the 3D point is not in view
   
    Script created by TheSnidr
    www.thesnidr.com
*/
var _x = argument0;
var _y = argument1;
var _z = argument2;
var V = argument3;
var P = argument4;
var width = argument5;
var height = argument6;
 
if (P[15] == 0) begin   //This is a perspective projection
    var w = V[2] * _x + V[6] * _y + V[10] * _z + V[14];
    if (w <= 0) return [-1, -1];
    var cx = P[8] + P[0] * (V[0] * _x + V[4] * _y + V[8] * _z + V[12]) / w;
    var cy = P[9] + P[5] * (V[1] * _x + V[5] * _y + V[9] * _z + V[13]) / w;
end else begin    //This is an ortho projection
    var cx = P[12] + P[0] * (V[0] * _x + V[4] * _y + V[8]  * _z + V[12]);
    var cy = P[13] + P[5] * (V[1] * _x + V[5] * _y + V[9]  * _z + V[13]);
end

// the original script had (0.5 - 0.5 * cy) for the y component, but that was
// causing things to be upside-down for some reason?
return [(0.5 + 0.5 * cx) * width, (0.5 - 0.5 * cy) * height];