/// @param target-x
/// @param target-y
/// @param target-z
/// @param cam-x
/// @param cam-y
/// @param cam-z
/// @param cam-xto
/// @param cam-yto
/// @param cam-zto
/// @param cam-xup
/// @param cam-yup
/// @param cam-zup
/// @param cam-fov
/// @param cam-width
/// @param cam-height

var xx = argument0;
var yy = argument1;
var zz = argument2;
var xfrom = argument3;
var yfrom = argument4;
var zfrom = argument5;
var xto = argument6;
var yto = argument7;
var zto = argument8;
var xup = argument9;
var yup = argument10;
var zup = argument11;
var fov = argument12;
var width = argument13;
var height = argument14;

var dX = xto - xfrom;
var dY = yto - yfrom;
var dZ = zto - zfrom;
var mm = sqrt(dX * dX + dY * dY + dZ * dZ);
dX /= mm;
dY /= mm;
dZ /= mm;
mm = xup * dX + yup * dY + zup * dZ;
xup -= mm * dX;
yup -= mm * dY;
zup -= mm * dZ;

mm = sqrt(xup * xup + yup * yup + zup * zup);
xup /= mm;
yup /= mm;
zup /= mm;
var tFOV = tan(fov * pi / 360);
xup *= tFOV;
yup *= tFOV;
zup *= tFOV;
var vX = yup * dZ - dY * zup;
var vY = zup * dX - dZ * xup;
var vZ = xup * dY - dX * yup;
vX *= width / height;
vY *= width / height;
vZ *= width / height;

var pX = xx - xfrom;
var pY = yy - yfrom;
var pZ = zz - zfrom;
mm = pX * dX + pY * dY + pZ * dZ;

if (mm > 0) begin
    pX /= mm;
    pY /= mm;
    pZ /= mm;
end else begin
    return [0, 0];
end

var mmx = (pX * vX + pY * vY + pZ * vZ) / sqr((width / height) * tan(pi / 8));
var mmy = (pX * xup + pY * yup + pZ * zup) / sqr(tan(pi / 8));

return [(mmx + 1) / 2 * width, (1 - mmy) / 2 * height];