/// @description void render_autotile(EntityAutoTile);
/// @param EntityAutoTile

var tile=argument0;
var TEXEL=1/TEXTURE_SIZE;

var xx=tile.xx*TILE_WIDTH;
var yy=tile.yy*TILE_HEIGHT;
var zz=tile.zz*TILE_DEPTH;
// todo correct normal calculation, and MAYBE normal smoothing, although
// i'm pretty sure that's going to be really expensive unless you bake it
// into the likely future map editing tool
var nx=0;
var ny=0;
var nz=1;

var tile_horizontal_count=TEXTURE_SIZE/Stuff.tile_size;
var tile_vertical_count=TEXTURE_SIZE/Stuff.tile_size;

// texture coordinates go from 0...1, not 0...n, where n is the dimension
// of the image in pixels
var texture_width=1/tile_horizontal_count;
var texture_height=1/tile_vertical_count;

var ts=get_active_tileset();

var ati=argument0.autotile_id;
var at_data=Stuff.available_autotiles[ati];
var at_position=ts.autotile_positions[ati];
// DO NOT TOUCH
var xtex=at_position[vec2.xx]+(argument0.segment_id mod at_data[AvailableAutotileProperties.WIDTH])*Stuff.tile_size/TEXTURE_SIZE;
var ytex=at_position[vec2.yy]+(argument0.segment_id div at_data[AvailableAutotileProperties.WIDTH])*Stuff.tile_size/TEXTURE_SIZE;

var color=tile.tile_color;
var alpha=tile.tile_alpha;

if (Camera.view_entities) {
    if (Camera.view_texture) {
        var tex=sprite_get_texture(ts.master, 0);
    } else {
        var tex=sprite_get_texture(b_tileset_textureless, 0)
    }
    
    d3d_primitive_begin_texture(pr_trianglelist, tex);
    
    d3d_vertex_normal_texture_colour(xx, yy, zz, nx, ny, nz, xtex+TEXEL, ytex+TEXEL, color, alpha);
    d3d_vertex_normal_texture_colour(xx+TILE_WIDTH, yy, zz, nx, ny, nz, xtex+texture_width-TEXEL, ytex+TEXEL, color, alpha);
    d3d_vertex_normal_texture_colour(xx+TILE_WIDTH, yy+TILE_HEIGHT, zz, nx, ny, nz, xtex+texture_width-TEXEL, ytex+texture_height-TEXEL, color, alpha);
    
    d3d_vertex_normal_texture_colour(xx+TILE_WIDTH, yy+TILE_HEIGHT, zz, nx, ny, nz, xtex+texture_width-TEXEL, ytex+texture_height-TEXEL, color, alpha);
    d3d_vertex_normal_texture_colour(xx, yy+TILE_HEIGHT, zz, nx, ny, nz, xtex+TEXEL, ytex+texture_height-TEXEL, color, alpha);
    d3d_vertex_normal_texture_colour(xx, yy, zz, nx, ny, nz, xtex+TEXEL, ytex+TEXEL, color, alpha);
    
    d3d_primitive_end();
}

if (Camera.view_wireframe) {
    d3d_primitive_begin_texture(pr_linelist, -1);
    
    d3d_vertex(xx, yy, zz);
    d3d_vertex(xx+TILE_WIDTH, yy, zz);
    
    d3d_vertex(xx+TILE_WIDTH, yy, zz);
    d3d_vertex(xx+TILE_WIDTH, yy+TILE_HEIGHT, zz);
    
    d3d_vertex(xx, yy, zz);
    d3d_vertex(xx+TILE_WIDTH, yy+TILE_HEIGHT, zz);
    
    d3d_vertex(xx+TILE_WIDTH, yy+TILE_HEIGHT, zz);
    d3d_vertex(xx, yy+TILE_HEIGHT, zz);
    
    d3d_vertex(xx, yy+TILE_HEIGHT, zz);
    d3d_vertex(xx, yy, zz);
    
    d3d_primitive_end();
}
