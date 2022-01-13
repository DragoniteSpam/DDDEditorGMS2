function Camera(x, y, z, xto, yto, zto, xup, yup, zup, fov, aspect, znear, zfar, direction, pitch) constructor {
    self.def_x = x;
    self.def_y = y;
    self.def_z = z;
    self.def_xto = xto;
    self.def_yto = yto;
    self.def_zto = zto;
    self.def_xup = xup;
    self.def_yup = yup;
    self.def_zup = zup;
    self.def_znear = znear;
    self.def_zfar = zfar;
    self.def_direction = direction;
    self.def_pitch = pitch;
    
    self.x = x;
    self.y = y;
    self.z = z;
    self.xto = xto;
    self.yto = yto;
    self.zto = zto;
    self.xup = xup;
    self.yup = yup;
    self.zup = zup;
    self.znear = znear;
    self.zfar = zfar;
    self.direction = direction;
    self.pitch = pitch;
    
    static Reset = function() {
        self.x = self.def_x;
        self.y = self.def_y;
        self.z = self.def_z;
        self.xto = self.def_xto;
        self.yto = self.def_yto;
        self.zto = self.def_zto;
        self.xup = self.def_xup;
        self.yup = self.def_yup;
        self.zup = self.def_zup;
        self.znear = self.def_znear;
        self.zfar = self.def_zfar;
        self.direction = self.def_direction;
        self.pitch = self.def_pitch;
    };
    
    static Save = function() {
        return {
            x: self.x,
            y: self.y,
            z: self.z,
            xto: self.xto,
            yto: self.yto,
            zto: self.zto,
            xup: self.xup,
            yup: self.yup,
            zup: self.zup,
            znear: self.znear,
            zfar: self.zfar,
            direction: self.direction,
            pitch: self.pitch,
        };
    };
    
    static Load = function(source) {
        self.x = source.def_x;
        self.y = source.def_y;
        self.z = source.def_z;
        self.xto = source.def_xto;
        self.yto = source.def_yto;
        self.zto = source.def_zto;
        self.xup = source.def_xup;
        self.yup = source.def_yup;
        self.zup = source.def_zup;
        self.znear = source.def_znear;
        self.zfar = source.def_zfar;
        self.direction = source.def_direction;
        self.pitch = source.def_pitch;
    };
}