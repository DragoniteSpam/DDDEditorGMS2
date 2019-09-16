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

var mm, dX, dY, dZ, uX, uY, uZ, vX, vY, vZ, mX, mY, mZ, width, height, tFOV, asp;
asp = argument[10];

// normalize TO vector
dX = argument[3] - argument[0];
dY = argument[4] - argument[1];
dZ = argument[5] - argument[2];
mm = sqrt(dX * dX + dY * dY + dZ * dZ);
dX /= mm;
dY /= mm;
dZ /= mm;

// fix UP vector and normalize it
uX = argument[6];
uY = argument[7];
uZ = argument[8];
mm = uX * dX + uY * dY + uZ * dZ;
uX -= mm * dX;
uY -= mm * dY;
uZ -= mm * dZ
mm = sqrt(uX * uX + uY * uY + uZ * uZ);
uX /= mm;
uY /= mm;
uZ /= mm;


// make x vector using TO and UP
vX = uY * dZ - dY * uZ;
vY = uZ * dX - dZ * uX;
vZ = uX * dY - dX * uY;

// convert angle to screen width and height
// not sure why this is pi/360 instead of pi/180 but that's the way
// it came and i don't want to touch it
tFOV = tan(argument[9] * pi / 360);
uX *= tFOV;
uY *= tFOV;
uZ *= tFOV;
vX *= tFOV * asp;
vY *= tFOV * asp;
vZ *= tFOV * asp;

// add UP * MOUSE_Y and X * MOUSE_X vector to TO vector
mX = dX + uX * (1 - 2 * fh) + vX * (2 * fw - 1);
mY = dY + uY * (1 - 2 * fh) + vY * (2 * fw - 1);
mZ = dZ + uZ * (1 - 2 * fh) + vZ * (2 * fw - 1);
mm = sqrt(mX * mX + mY * mY + mZ * mZ);

// normalize mouse direction vector
return vector3(mX / mm, mY / mm, mZ / mm);