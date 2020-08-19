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
function update_mouse_vector() {

    // Pretty sure this is an adapted version of code written by a guy called Yourself on the
    // game maker forums, but i can't find the original thread

    var xfrom = argument[0];
    var yfrom = argument[1];
    var zfrom = argument[2];
    var xto = argument[3];
    var yto = argument[4];
    var zto = argument[5];
    var xup = argument[6];
    var yup = argument[7];
    var zup = argument[8];
    var fov = argument[9];
    var aspect = argument[10];
    var fw = (argument_count > 11) ? argument[11] : (mouse_x / CW);
    var fh = (argument_count > 12) ? argument[12] : (mouse_y / CH);

    var asp = argument[10];

    // normalize TO vector
    var dX = xto - xfrom;
    var dY = yto - yfrom;
    var dZ = zto - zfrom;
    var mm = point_distance_3d(0, 0, 0, dX, dY, dZ);
    dX /= mm;
    dY /= mm;
    dZ /= mm;

    // normalize the up vector
    mm = xup * dX + yup * dY + zup * dZ;
    xup -= mm * dX;
    yup -= mm * dY;
    zup -= mm * dZ
    mm = point_distance_3d(0, 0, 0, xup, yup, zup);
    xup /= mm;
    yup /= mm;
    zup /= mm;

    // make x vector using TO and UP
    var vX = yup * dZ - dY * zup;
    var vY = zup * dX - dZ * xup;
    var vZ = xup * dY - dX * yup;

    // convert angle to screen width and height
    var tFOV = tan(fov * pi / 360);
    xup *= tFOV;
    yup *= tFOV;
    zup *= tFOV;
    vX *= tFOV * asp;
    vY *= tFOV * asp;
    vZ *= tFOV * asp;

    // add UP * mouse_y and X * mouse_x vector to TO vector
    var mX = dX + xup * (1 - 2 * fh) + vX * (2 * fw - 1);
    var mY = dY + yup * (1 - 2 * fh) + vY * (2 * fw - 1);
    var mZ = dZ + zup * (1 - 2 * fh) + vZ * (2 * fw - 1);
    mm = point_distance_3d(0, 0, 0, mX, mY, mZ);

    // normalize mouse direction vector
    return [mX / mm, mY / mm, mZ / mm];


}
