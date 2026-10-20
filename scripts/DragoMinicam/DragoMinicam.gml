function DragoMinicam(x, y, w, h) constructor {
    self.x = x;
    self.y = y;
    self.w = w;
    self.h = h;
    self.zoom = 1;  // this is the scale that the view should be drawn at; 0.5x is zoomed in, 2x is zoomed out
    self.zoom_target = 1;
    
    self.locked = false;
    
    static Update = function(mx, my, x1 = -infinity, y1 = -infinity, x2 = infinity, y2 = infinity) {
        self.zoom = lerp(self.zoom, self.zoom_target, 0.25);
        
        if (abs(self.zoom - self.zoom_target) < 0.002) {
            self.zoom = self.zoom_target;
        }
        
        if (!self.locked && !point_in_rectangle(mx, my, x1, y1, x2, y2)) {
            return;
        }
        
        if (mouse_check_button_pressed(mb_middle)) {
            self.locked = true;
        }
        
        if (!mouse_check_button(mb_middle)) {
            self.locked = false;
        }
        
        var zoom_step = 0.125;
        if (self.zoom_target < 0.5) {
            zoom_step = 0.03125;
        } else if (self.zoom_target < 0.75) {
            zoom_step = 0.0625;
        } else if (self.zoom_target > 2) {
            zoom_step = 0.5;
        }
        
        if (mouse_wheel_up()) {
            self.zoom_target = max(0.25, self.zoom_target - zoom_step);
        } else if (mouse_wheel_down()) {
            self.zoom_target = min(5, self.zoom_target + zoom_step);
        }
        
        if (self.locked) {
            var dx = window_mouse_get_delta_x() * self.zoom;
            var dy = window_mouse_get_delta_y() * self.zoom;
            
            self.x -= dx;
            self.y -= dy;
        }
    };
    
    static Apply = function() {
        static view_mat = matrix_build_identity();
        static proj_mat = matrix_build_identity();
        static camera = camera_create();
        matrix_build_lookat(self.x, self.y, 100, self.x, self.y, 0, 0, -1, 0, view_mat);
        matrix_build_projection_ortho(self.w * self.zoom, -self.h * self.zoom, 1, 1000, proj_mat);
        camera_set_view_mat(camera, view_mat);
        camera_set_proj_mat(camera, proj_mat);
        camera_apply(camera);
    }
}