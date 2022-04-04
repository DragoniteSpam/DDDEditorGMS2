function screen_to_world(x, y, V, P, w, h) {
    /*
        Transforms a 2D coordinate (in window space) to a 3D vector.
        Returns an array of the following format:
        [dx, dy, dz, ox, oy, oz]
        where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.
        Works for both orthographic and perspective projections.
        Script created by TheSnidr
        (slightly modified by @dragonitespam)
    */
    
    var mx = 2 * (x / w - .5) / P[0];
    var my = -2 * (y / h - .5) / P[5];
    var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
    var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
    var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);
    
    if (P[15] == 0) {    //This is a perspective projection
        return {
            direction: new Vector3(V[2]  + mx * V[0] + my * V[1], V[6]  + mx * V[4] + my * V[5], V[10] + mx * V[8] + my * V[9]),
            origin: new Vector3(camX, camY, camZ)
        }
    } else {    //This is an ortho projection
        return {
            direction: new Vector3(V[2], V[6], V[10]),
            origin: new Vector3(camX + mx * V[0] + my * V[1], camY + mx * V[4] + my * V[5], camZ + mx * V[8] + my * V[9])
        };
    }
}

function world_to_screen(x, y, z, V, P, w, h) {
    /*
        Transforms a 3D world-space coordinate to a 2D window-space coordinate. Returns an array of the following format:
        [x, y]
        Returns [-1, -1] if the 3D point is not in view
   
        Script created by TheSnidr
        www.thesnidr.com
    */
    
    if (P[15] == 0) {   //This is a perspective projection
        var ww = V[2] * x + V[6] * y + V[10] * z + V[14];
        if (ww == 0) return new Vector2(-1, -1);
        var cx = P[8] + P[0] * (V[0] * x + V[4] * y + V[8] * z + V[12]) / ww;
        var cy = P[9] + P[5] * (V[1] * x + V[5] * y + V[9] * z + V[13]) / ww;
        // the original script had (0.5 - 0.5 * cy) for the y component, but that was
        // causing things to be upside-down for some reason?
        return new Vector2((0.5 + 0.5 * cx) * w, (0.5 + 0.5 * cy) * h);
    } else {    //This is an ortho projection
        var cx = P[12] + P[0] * (V[0] * x + V[4] * y + V[8]  * z + V[12]);
        var cy = P[13] + P[5] * (V[1] * x + V[5] * y + V[9]  * z + V[13]);
        // the original script had (0.5 - 0.5 * cy) for the y component, but that was
        // causing things to be upside-down for some reason?
        return new Vector2((0.5 + 0.5 * cx) * w, (0.5 + 0.5 * cy) * h);
    }
}