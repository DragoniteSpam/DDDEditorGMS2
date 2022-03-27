function EmuFileDropperListener(action) : EmuCore(0, 0, 0, 0) constructor {
    self.action = method(self, action);
    
    static Render = function() {
        if (!self.root.isActiveDialog()) return;
        if (array_length(Stuff.files_dropped) > 0) {
            self.action(Stuff.files_dropped);
        }
    };
}