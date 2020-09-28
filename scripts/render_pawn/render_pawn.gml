/// @param EntityPawn
function render_pawn(argument0) {

    var pawn = argument0;
    var xx = pawn.xx;
    var yy = pawn.yy;
    var zz = pawn.zz;

    var data = guid_get(pawn.overworld_sprite);
    data = data ? data : Stuff.default_pawn;
    var spritesheet_height = 4;
    var spritesheet_frames = data ? data.hframes : 4;

    if (pawn.is_animating) {
        pawn.frame = (pawn.frame + Stuff.setting_npc_animate_rate * (delta_time / MILLION)) % spritesheet_frames;
    }

    var index = pawn.map_direction * data.hframes + floor(pawn.frame);

    transform_set(xx * TILE_WIDTH, yy * TILE_HEIGHT, zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    vertex_submit(data ? data.npc_frames[index] : Stuff.graphics.base_npc, pr_trianglelist, sprite_get_texture(data ? data.picture : spr_pawn_missing, 0));
    transform_reset();


}
