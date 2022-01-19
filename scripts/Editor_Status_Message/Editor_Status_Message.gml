#macro DEFAULT_STATUS_MESSAGE_DURATION                                          8

function StatusMessage(text, duration = DEFAULT_STATUS_MESSAGE_DURATION) constructor {
    self.text = text;
    self.duration = duration;
    self.x = 32;
    self.y = 48;
    
    array_insert(Stuff.status_messages, 0, self);
    
    static Update = function(target_y) {
        self.y = lerp(self.y, target_y, 0.1);
        self.duration -= Stuff.dt;
        return self.duration > 0;
    };
    
    static Render = function() {
        scribble_set_blend(c_white, min(1, self.duration));
        scribble_set_box_align(fa_left, fa_top);
        scribble_set_wrap(window_get_width() - 64, 32);
        scribble_draw(self.x, self.y, self.text);
        scribble_set_blend(c_white, 1);
    };
}