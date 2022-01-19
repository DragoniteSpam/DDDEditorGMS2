#macro DEFAULT_STATUS_MESSAGE_DURATION                                          8

function StatusMessage(text, duration = DEFAULT_STATUS_MESSAGE_DURATION) {
    self.text = text;
    self.duration = duration;
    self.x = 0;
    self.y = 0;
    
    static Update = function() {
        self.duration -= Stuff.dt;
        return self.duration > 0;
    };
    
    static Render = function() {
        scribble_set_blend(c_white, min(1, self.duration));
        scribble_draw(self.x, self.y, self.text);
        scribble_set_blend(c_white, 1);
    };
}