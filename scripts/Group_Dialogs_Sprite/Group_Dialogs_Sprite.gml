function sprite_dialog_rearrange(sprite) {
    var dialog = new EmuDialog(960, 800, "Rearrange Sprite");
    dialog.sprite = sprite;
    dialog.AddContent([
        new EmuRenderSurface(32, 32, 960 - 64, 800 - 96, function(mx, my) {
            // render
            self.minicam.Apply();
            
            draw_sprite_tiled(spr_emu_checker, 0, 0, 0);
            
            draw_sprite(self.root.sprite.picture, 0, 0, 0);
        }, function(mx, my) {
            // step
            
            self.minicam.Update(mx, my, 0, 0, self.width - 1, self.height - 1);
        }, function() {
            // create
            self.minicam = new Minicam(self.width / 2, self.height / 2, self.width, self.height);
        })
    ]);
    dialog.AddDefaultConfirmCancelButtons("Confirm", function() {
        // confirm
    }, "Cancel", function() {
        // cancel
    });
    return dialog;
}

function Minicam(x, y, w, h) constructor {
    self.x = x;
    self.y = y;
    self.w = w;
    self.h = h;
    self.zoom = 1;  // this is the scale that the view should be drawn at; 0.5x is zoomed in, 2x is zoomed out
    
    self.locked = false;
    
    static Update = function(mx, my, x1 = -infinity, y1 = -infinity, x2 = infinity, y2 = infinity) {
        if (!self.locked && !point_in_rectangle(mx, my, x1, y1, x2, y2)) {
            return;
        }
        
        if (mouse_check_button_pressed(mb_middle)) {
            self.locked = true;
        }
        
        if (!mouse_check_button(mb_middle)) {
            self.locked = false;
        }
        
        if (mouse_wheel_up()) {
            self.zoom = max(0.25, self.zoom - 0.125);
        } else if (mouse_wheel_down()) {
            self.zoom = min(5, self.zoom + 0.125);
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