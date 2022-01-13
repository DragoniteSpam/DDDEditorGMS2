function Camera(x, y, z, xto, yto, zto, xup, yup, zup, fov, znear, zfar, callback) constructor {
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
    self.callback = method(self, callback);
    
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
    
    self.view_mat = undefined;
    self.proj_mat = undefined;
    
    static Update = function() {
        if (self.view_mat == undefined || self.proj_mat == undefined) return;
        
        self.callback(screen_to_world(window_mouse_get_x(), window_get_height() - window_mouse_get_y(), self.view_mat, self.proj_mat, CW, CH));
        
        // move the camera
        var mspd = self.GetCameraSpeed();
        var xspeed = 0;
        var yspeed = 0;
        var zspeed = 0;
        
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            xspeed += dcos(self.direction) * mspd;
            yspeed -= dsin(self.direction) * mspd;
            zspeed -= dsin(self.pitch) * mspd;
        }
        
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            xspeed -= dcos(self.direction) * mspd;
            yspeed += dsin(self.direction) * mspd;
            zspeed += dsin(self.pitch) * mspd;
        }
        
        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
            xspeed -= dsin(self.direction) * mspd;
            yspeed -= dcos(self.direction) * mspd;
        }
        
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
            xspeed += dsin(self.direction) * mspd;
            yspeed += dcos(self.direction) * mspd;
        }
        
        if (CONTROL_3D_LOOK_DOWN) {
            var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) div 2;
            var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) div 2;
            window_mouse_set(camera_cx, camera_cy);
        } else if (CONTROL_3D_LOOK) {
            var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) div 2;
            var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) div 2;
            window_mouse_set(camera_cx, camera_cy);
            var dx = (mouse_x - camera_cx) / 16;
            var dy = (mouse_y - camera_cy) / 16;
            self.direction = (360 + self.direction - dx) % 360;
            self.pitch = clamp(self.pitch + dy, -89, 89);
            self.xto = self.x + dcos(self.direction) * dcos(self.pitch);
            self.yto = self.y - dsin(self.direction) * dcos(self.pitch);
            self.zto = self.z - dsin(self.pitch);
        }
        
        self.x += xspeed;
        self.y += yspeed;
        self.z += zspeed;
        self.xto += xspeed;
        self.yto += yspeed;
        self.zto += zspeed;
        self.xup = 0;
        self.yup = 0;
        self.zup = 1;
    };
    
    static UpdateOrtho = function() {
        if (self.view_mat == undefined || self.proj_mat == undefined) return;
        
        self.callback(screen_to_world(window_mouse_get_x(), window_get_height() - window_mouse_get_y(), self.view_mat, self.proj_mat, CW, CH));
        
        // move the camera
        if (!keyboard_check(vk_control)) {
            var mspd = 4;
            var xspeed = 0;
            var yspeed = 0;
            
            if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                yspeed = yspeed - mspd;
            }
            
            if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                yspeed = yspeed + mspd;
            }
            
            if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
                xspeed = xspeed - mspd;
            }
            
            if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
                xspeed = xspeed + mspd;
            }
            
            if (mouse_wheel_up()) {
                self.scale = max(0.5, self.scale * 0.95);
            } else if (mouse_wheel_down()) {
                self.scale = min(10, self.scale * 1.05);
            }
            
            self.x += xspeed;
            self.y += yspeed;
            self.xto += xspeed;
            self.yto += yspeed;
        }
    };
    
    static SetProjection = function() {
        var camera = view_get_camera(view_current);
        var vw = view_get_wport(view_current);
        var vh = view_get_hport(view_current);
        
        self.view_mat = matrix_build_lookat(self.x, self.y, self.z, self.xto, self.yto, self.zto, self.xup, self.yup, self.zup);
        self.proj_mat = matrix_build_projection_perspective_fov(-self.fov, -vw / vh, self.znear, self.zfar);
        
        camera_set_view_mat(camera, self.view_mat);
        camera_set_proj_mat(camera, self.proj_mat);
        camera_apply(camera);
    };
    
    static SetProjectionOrtho = function() {
        var camera = view_get_camera(view_current);
        var vw = view_get_wport(view_current);
        var vh = view_get_hport(view_current);
        
        self.view_mat = matrix_build_lookat(self.x, self.y, self.zfar - 256, self.x, self.y, 0, 0, 1, 0);
        self.proj_mat = matrix_build_projection_ortho(-vw * self.scale, vh * self.scale, self.znear, self.zfar);
        
        camera_set_view_mat(camera, self.view_mat);
        camera_set_proj_mat(camera, self.proj_mat);
        camera_apply(camera);
    };
    
    static DrawSkybox = function() {
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        transform_set(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
    };
    
    static DrawSkyboxOrtho = function() {
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        transform_set(self.x, self.y, self.zfar - 256, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
        gpu_set_zwriteenable(true);
        gpu_set_ztestenable(true);
    };
    
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
            self.Reset();
        }
    };
    
    static GetCameraSpeed = function() {
        var base_speed = 256;
        var accelerate_time = 6;
        return max(1, (base_speed * (logn(32, max(self.z, 1)) + 1)) * Stuff.dt * min((Controller.time_wasd_seconds + 1) / accelerate_time * Settings.config.camera_fly_rate, 10));
    };
}