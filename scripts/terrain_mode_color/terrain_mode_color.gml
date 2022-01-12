function terrain_mode_color(terrain, position) {
    terrain.color.Paint(position.x * terrain.color_scale, position.y * terrain.color_scale, terrain.radius * terrain.color_scale, terrain.paint_color, terrain.paint_strength);
}