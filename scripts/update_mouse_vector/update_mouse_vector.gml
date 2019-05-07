/// @description  void update_mouse_vector(xfrom, yfrom, zfrom, xto, yto, zto, xup, yup, zup, fov, aspect);
/// @param xfrom
/// @param  yfrom
/// @param  zfrom
/// @param  xto
/// @param  yto
/// @param  zto
/// @param  xup
/// @param  yup
/// @param  zup
/// @param  fov
/// @param  aspect
// Pretty suret his is an adapted version of code written by a
// guy called Yourself on the game maker forums, but i can't
// find the original thread.
var mm,dX,dY,dZ,uX,uY,uZ,vX,vY,vZ,mX,mY,mZ,width,height,tFOV,asp;
asp=argument10;

// normalize TO vector
dX = argument3-argument0;
dY = argument4-argument1;
dZ = argument5-argument2;
mm = sqrt(dX*dX+dY*dY+dZ*dZ);
dX /= mm;
dY /= mm;
dZ /= mm;

// fix UP vector and normalize it
uX = argument6;
uY = argument7;
uZ = argument8;
mm = uX*dX+uY*dY+uZ*dZ;
uX -= mm*dX;
uY -= mm*dY;
uZ -= mm*dZ
mm = sqrt(uX*uX+uY*uY+uZ*uZ);
uX /= mm;
uY /= mm;
uZ /= mm;


// make x vector using TO and UP
vX = uY*dZ-dY*uZ;
vY = uZ*dX-dZ*uX;
vZ = uX*dY-dX*uY;

// convert angle to screen width and height
// not sure why this is pi/360 instead of pi/180 but that's the way
// it came and i don't want to touch it
tFOV = tan(argument9*pi/360);
uX *= tFOV;
uY *= tFOV;
uZ *= tFOV;
vX *= tFOV*asp;
vY *= tFOV*asp;
vZ *= tFOV*asp;

// add UP*MOUSE_Y and X*MOUSE_X vector to TO vector
mX = dX+uX*(1-2*MOUSE_Y/CH)+vX*(2*MOUSE_X/CW-1);
mY = dY+uY*(1-2*MOUSE_Y/CH)+vY*(2*MOUSE_X/CW-1);
mZ = dZ+uZ*(1-2*MOUSE_Y/CH)+vZ*(2*MOUSE_X/CW-1);
mm = sqrt(mX*mX+mY*mY+mZ*mZ);

// normalize mouse direction vector
return array_compose(mX/mm, mY/mm, mZ/mm);
