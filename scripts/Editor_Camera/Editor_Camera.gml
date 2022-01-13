function Camera(x, y, z, xto, yto, zto, xup, yup, zup, fov, znear, zfar) constructor {
    self.def_x = x;
    self.def_y = y;
    self.def_z = z;
    self.def_xto = xto;
    self.def_yto = yto;
    self.def_zto = zto;
    self.def_xup = xup;
    self.def_yup = yup;
    self.def_zup = zup;
    self.def_fov = fov;
    self.def_direction = darctan2(z - zto, point_distance(x, y, xto, yto));
    self.def_pitch = point_direction(x, y, xto, yto);
    
    self.znear = znear;
    self.zfar = zfar;
    
    self.x = x;
    self.y = y;
    self.z = z;
    self.xto = xto;
    self.yto = yto;
    self.zto = zto;
    self.xup = xup;
    self.yup = yup;
    self.zup = zup;
    self.fov = fov;
    self.direction = self.def_direction;
    self.pitch = self.def_pitch;
    self.scale = 1;
    
    static SetProjection = function() {
        var camera = view_get_camera(view_current);
        var vw = view_get_wport(view_current);
        var vh = view_get_hport(view_current);
        
        var view = matrix_build_lookat(self.x, self.y, self.z, self.xto, self.yto, self.zto, self.xup, self.yup, self.zup);
        var proj = matrix_build_projection_perspective_fov(-self.fov, -vw / vh, self.znear, self.zfar);
        
        camera_set_view_mat(camera, view);
        camera_set_proj_mat(camera, proj);
        camera_apply(camera);
    };
    
    static SetProjectionOrtho = function() {
        var camera = view_get_camera(view_current);
        var vw = view_get_wport(view_current);
        var vh = view_get_hport(view_current);
        
        var view = matrix_build_lookat(x, y, self.zfar - 256, x, y, 0, 0, 1, 0);
        var proj = matrix_build_projection_ortho(-vw * self.scale, vh * self.scale, self.znear, self.zfar);
        
        camera_set_view_mat(camera, view);
        camera_set_proj_mat(camera, proj);
        camera_apply(camera);
    };
    
    static DrawSkybox = function() {
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        transform_set(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
    }
    
    static DrawSkyboxOrtho = function() {
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        transform_set(self.x, self.y, self.zfar - 256, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
    }
    
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
        self.fov = self.def_fov;
        self.direction = self.def_direction;
        self.pitch = self.def_pitch;
        self.scale = 1;
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
            fov: self.fov,
            direction: self.direction,
            pitch: self.pitch,
        };
    };
    
    static Load = function(source) {
        try {
            self.x = source.x;
            self.y = source.y;
            self.z = source.z;
            self.xto = source.xto;
            self.yto = source.yto;
            self.zto = source.zto;
            self.xup = source.xup;
            self.yup = source.yup;
            self.zup = source.zup;
            self.fov = source.fov;
            self.direction = source.direction;
            self.pitch = source.pitch;
        } catch (e) {
            self.x = self.def_x;
            self.y = self.def_y;
            self.z = self.def_z;
            self.xto = self.def_xto;
            self.yto = self.def_yto;
            self.zto = self.def_zto;
            self.xup = self.def_xup;
            self.yup = self.def_yup;
            self.zup = self.def_zup;
            self.fov = self.def_fov;
            self.direction = self.def_direction;
            self.pitch = self.def_pitch;
        }
    };
}