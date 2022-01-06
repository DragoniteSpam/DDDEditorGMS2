var files = drago_get_dropped_files();
if (array_length(files) > 0) {
    self.files_dropped = files;
} else {
    self.files_dropped = [];
}

if (is_struct(self.mode)) {
    self.mode.Update();
} else {
    self.mode.update(mode);
}