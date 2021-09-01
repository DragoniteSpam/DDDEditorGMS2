function terrain_mode_color(terrain, position, color, strength) {
    if (color == undefined) color = terrain.paint_color;
    if (strength == undefined) strength = terrain.paint_strength;
    
    terrain.color.Paint(position.x * terrain.color_scale, position.y * terrain.color_scale, terrain.radius * terrain.color_scale, color, strength);
}