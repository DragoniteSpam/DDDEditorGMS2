/// @param EntityPawn

var pawn = argument0;
var xx = pawn.xx;
var yy = pawn.yy;
var zz = pawn.zz;

var spritesheet_height = 4;
var spritesheet_frames = 4;

if (pawn.is_animating) {
    pawn.frame = (pawn.frame + Stuff.setting_npc_animate_rate * (delta_time / MILLION)) % 4;
}

var frame = floor(pawn.frame) % spritesheet_frames;

// if you're on the grid you don't need to do the modulo thing because it'll reset at the end of each walk cycle, but on the grid you do
var dir = pawn.map_direction;
var frame_width = sprite_get_width(pawn.overworld_sprite) / spritesheet_frames;
var frame_height = sprite_get_height(pawn.overworld_sprite) / spritesheet_height;

var angle = Stuff.active_map.is_3d ? 60 : 0;
var xoffset = 0;
var yoffset = Stuff.active_map.is_3d ? TILE_HEIGHT / 2 : TILE_HEIGHT;
var zoffset = Stuff.active_map.is_3d ? 0 : 1;
transform_set(0, -TILE_HEIGHT, 0, 0, 0, 0, 1, 1, 1);
transform_add(0, 0, 0, angle, 0, 0, 1, 1, 1);
transform_add(xx * TILE_WIDTH + xoffset, yy * TILE_HEIGHT + yoffset, zz * TILE_DEPTH + zoffset, 0, 0, 0, 1, 1, 1);

draw_sprite_part_ext(pawn.overworld_sprite, 0, frame * frame_width, dir * frame_height, frame_width, frame_height, 0, 0, TILE_WIDTH / frame_width, TILE_HEIGHT / frame_height, c_white, 1);

transform_reset();