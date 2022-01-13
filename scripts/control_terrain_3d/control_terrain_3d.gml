function control_terrain_3d(terrain) {
    if (Stuff.menu.active_element) {
        return false;
    }
    
    self.camera.Update();
}