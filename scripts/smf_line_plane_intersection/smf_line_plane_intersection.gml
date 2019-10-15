/// @description line_plane_intersection(lineStart, lineEnd, planePos, planeN)
/// @param lineStart[3]}
/// @param lineEnd[3]
/// @param planePos[3]
/// @param planeN[3]
/*
Script made by TheSnidr

www.thesnidr.com
*/
gml_pragma("forceinline");

var lineStart, lineEnd, planePos, planeN, d, t;
lineStart = argument0;
lineEnd = argument1;
planePos = argument2;
planeN = argument3;
d = [lineEnd[0] - lineStart[0], lineEnd[1] - lineStart[1], lineEnd[2] - lineStart[2]];
t = d[0] * planeN[0] + d[1] * planeN[1] + d[2] * planeN[2];
if t == 0{return false;}
t = ((planePos[0] - lineStart[0]) * planeN[0] + (planePos[1] - lineStart[1]) * planeN[1] + (planePos[2] - lineStart[2]) * planeN[2]) / t;
if t < 0 or t > 1{return false;}
return [lineStart[0] + d[0] * t, lineStart[1] + d[1] * t, lineStart[2] + d[2] * t];