/// @param Dialog

var dw = 720;
var dh = 400;

var dg = dialog_create(dw, dh, "Credits", dialog_default, dc_close_no_questions_asked, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var yy = 64;
var el_text = create_text(16, yy, "DDD Game Editor", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_author = create_text(16, yy, "Author: DragoniteSpam", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_author_1 = create_text(32, yy, "     Twitter: https://twitter.com/DragoniteSpam", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_author_2 = create_text(32, yy, "     Github: https://github.com/DragoniteSpam", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_author_3 = create_text(32, yy, "     YouTube: https://www.youtube.com/c/DragoniteSpam", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_help = create_text(16, yy, "With help from:", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_help_who = create_text(32, yy, "     RatcheT2497", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_ex = create_text(16, yy, "Some Game Maker extensions were used", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_ex_venomous = create_text(32, yy, "     3D collisions (mostly raycasting): Venomous Bullet implementation", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_venomous_url = create_text(32, yy, "          http://gmc.yoyogames.com/index.php?showtopic=632606", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_regex = create_text(32, yy, "     There's a really great regex extension by Upset Baby Games", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_regex_url = create_text(32, yy, "          but it appears to have been delisted", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_fmod = create_text(32, yy, "     FMODGMS by quadolorgames:", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_fmod_url = create_text(32, yy, "          https://quadolorgames.itch.io/fmodgms", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_smf = create_text(32, yy, "     Snidr's Model Format by himself:", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_ex_smf_url = create_text(32, yy, "          https://marketplace.yoyogames.com/assets/5256/smf-3d-skeletal-animation", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_asset = create_text(32, yy, "Default assets", ew, eh, fa_left, dw - 32, dg);
yy = yy + 32;
var el_asset_water = create_text(32, yy, "     Water textures: Aswin Vos and www.godsandidolds.com", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;
var el_asset_npc = create_text(32, yy, "     Default NPC: Lanea Zimmerman", ew, eh, fa_left, dw - 32, dg);
yy = yy + 16;

// this is easier than resizing the dialog manually every time (up to the point where it flows off the screen)
dh = yy + 96;
dg.height = dh;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Thanks I guess", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_text, el_author, el_author_1, el_author_2, el_author_3, el_help, el_help_who,
    el_ex, el_ex_venomous, el_ex_venomous_url, el_ex_regex, el_ex_regex_url, el_ex_fmod, el_ex_fmod_url, el_ex_smf, el_ex_smf_url,
    el_asset, el_asset_water, el_asset_npc,
    el_close
);

return dg;