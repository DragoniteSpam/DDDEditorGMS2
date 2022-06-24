function EmuFileDropperListener(action) : EmuCore(0, 0, 0, 0) constructor {
    self.action = method(self, action);
    
    self.Filter = function(files, extensions) {
        var filtered_list = [];
        var extension_map = { };
        
        for (var j = 0; j < array_length(extensions); j++) {
            extension_map[$ string_lower(extensions[j])] = true;
        }
        
        for (var i = 0; i < array_length(files); i++) {
            var fn = string_lower(files[i]);
            if (extension_map[$ filename_ext(fn)]) {
                array_push(filtered_list, fn);
            }
        }
        
        return filtered_list;
    };
    
    self.Render = function() {
        if (!self.root.isActiveDialog()) return;
        if (array_length(Stuff.files_dropped) > 0) {
            self.action(Stuff.files_dropped);
        }
    };
}