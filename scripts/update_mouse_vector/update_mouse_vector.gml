/// @param xfrom
/// @param yfrom
/// @param zfrom
/// @param xto
/// @param yto
/// @param zto
/// @param xup
/// @param yup
/// @param zup
/// @param fov
/// @param aspect
/// @param [fraction-w]
/// @param [fraction-h]

// Pretty sure this is an adapted version of code written by a guy called Yourself on the
// game maker forums, but i can't find the original thread

var fw = (argument_count > 11) ? argument[11] : (Camera.MOUSE_X / CW);
var fh = (argument_count > 12) ? argument[12] : (Camera.MOUSE_Y / CH);

var asp = argument[10];

// normalize TO vector
var dX = argument[3] - argument[0];
var dY = argument[4] - argument[1];
var dZ = argument[5] - argument[2];
var mm = sqrt(dX * dX + dY * dY + dZ * dZ);
dX /= mm;
dY /= mm;
dZ /= mm;

// fix UP vector and normalize it
var uX = argument[6];
var uY = argument[7];
var uZ = argument[8];
mm = uX * dX + uY * dY + uZ * dZ;
uX -= mm * dX;
uY -= mm * dY;
uZ -= mm * dZ
mm = sqrt(uX * uX + uY * uY + uZ * uZ);
uX /= mm;
uY /= mm;
uZ /= mm;

// make x vector using TO and UP
var vX = uY * dZ - dY * uZ;
var vY = uZ * dX - dZ * uX;
var vZ = uX * dY - dX * uY;

// convert angle to screen width and height
var tFOV = tan(argument[9] * pi / 360);
uX *= tFOV;
uY *= tFOV;
uZ *= tFOV;
vX *= tFOV * asp;
vY *= tFOV * asp;
vZ *= tFOV * asp;

// add UP * MOUSE_Y and X * MOUSE_X vector to TO vector
var mX = dX + uX * (1 - 2 * fh) + vX * (2 * fw - 1);
var mY = dY + uY * (1 - 2 * fh) + vY * (2 * fw - 1);
var mZ = dZ + uZ * (1 - 2 * fh) + vZ * (2 * fw - 1);
mm = sqrt(mX * mX + mY * mY + mZ * mZ);

// normalize mouse direction vector
return vector3(mX / mm, mY / mm, mZ / mm);