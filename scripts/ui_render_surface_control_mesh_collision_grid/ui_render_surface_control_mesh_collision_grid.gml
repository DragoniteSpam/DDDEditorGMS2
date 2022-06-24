function ui_render_surface_control_mesh_collision_grid(surface, x1, y1, x2, y2) {
    var mesh = surface.root.mesh;
    
    if (mouse_within_rectangle(x1, y1, x2, y2)) {
        var hcount = mesh.xmax - mesh.xmin;
        var vcount = mesh.ymax - mesh.ymin;
        var hstep = (x2 - x1) / max(hcount, 1);
        var vstep = (y2 - y1) / max(vcount, 1);
        hstep = min(hstep, vstep);
        vstep = hstep;
        
        if (Controller.press_left) {
            var xcell = min((mouse_x - x1) div hstep, surface.root.el_x_input.value_upper);
            var ycell = min((mouse_y - y1) div vstep, surface.root.el_y_input.value_upper);
            surface.root.xx = xcell;
            surface.root.yy = ycell;
            surface.root.el_x_input.value = string(xcell);
            surface.root.el_x.value = xcell / max(surface.root.el_x_input.value_upper, 1);
            surface.root.el_y_input.value = string(ycell);
            surface.root.el_y.value = ycell / max(surface.root.el_y_input.value_upper, 1);
            surface.root.el_collision_triggers.value = mesh.asset_flags[xcell][ycell][surface.root.zz];
        }
    }
}