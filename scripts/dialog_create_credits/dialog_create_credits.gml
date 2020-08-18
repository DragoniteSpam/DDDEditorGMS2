/// @param Dialog
function dialog_create_credits(argument0) {

	var dw = 960;
	var dh = 400;

	var dg = dialog_create(dw, dh, "Credits", dialog_default, dc_close_no_questions_asked, argument0);

	var columns = 1;
	var spacing = 16;
	var ew = dw / columns - spacing * 2;
	var eh = 24;
	var bw = ew / 5;

	var yy = 64;
	var el_text = create_text(16, yy, "[FDefault20][c_blue]DDD Game Editor", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_author = create_text(16, yy, "Author: Michael Peng (DragoniteSpam)", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_author_1 = create_button(32 + (bw + spacing) * 0, yy, "Twitter", bw, eh, fa_center, uivc_url_ds_twitter, dg);
	el_author_1.tooltip = "https://twitter.com/dragonitespam";
	var el_author_2 = create_button(32 + (bw + spacing) * 1, yy, "YouTube", bw, eh, fa_center, uivc_url_ds_youtube, dg);
	el_author_2.tooltip = "https://www.youtube.com/c/dragonitespam/about";
	var el_author_3 = create_button(32 + (bw + spacing) * 2, yy, "Github", bw, eh, fa_center, uivc_url_ds_github, dg);
	el_author_3.tooltip = "https://github.com/DragoniteSpam";
	var el_author_4 = create_button(32 + (bw + spacing) * 3, yy, "Itch.io", bw, eh, fa_center, uivc_url_ds_itch, dg);
	el_author_4.tooltip = "https://dragonite.itch.io/";
	yy += 40;

	var el_help = create_text(16, yy, "[c_blue]With help from:", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_help_who = create_text(32, yy, "     RatcheT2497, Nate Robbins, YouTube stream chat", ew, eh, fa_left, dw - 32, dg);
	yy += 40;

	var el_ex = create_text(16, yy, "[c_blue]Some Game Maker extensions were used", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_venomous_url = create_button(32, yy, "GMC Forum thread", bw, eh, fa_center, uivc_url_venomous_collision, dg);
	el_ex_venomous_url.tooltip = "http://gmc.yoyogames.com/index.php?showtopic=632606 (Web Archive; the original page has long since been deleted)";
	var el_ex_venomous = create_text(32 + bw + spacing, yy, "     3D collisions (mostly raycasting): Venomous (Bullet)", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_fmod_url = create_button(32, yy, "itch.io (free)", bw, eh, fa_center, uivc_url_fmodgms, dg);
	el_ex_fmod_url.tooltip = "https://quadolorgames.itch.io/fmodgms";
	var el_ex_fmod = create_text(32 + bw + spacing, yy, "FMODGMS by quadolorgames", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_smf_url = create_button(32, yy, "Marketplace (free)", bw, eh, fa_center, uivc_url_smf, dg);
	el_ex_smf_url.tooltip = "https://marketplace.yoyogames.com/assets/5256/smf-3d-skeletal-animation";
	var el_ex_smf = create_text(32 + bw + spacing, yy, "Snidr's Model Format, by the heavy metal viking dentist himself", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_scribble_url = create_button(32, yy, "Github", bw, eh, fa_center, uivc_url_scribble, dg);
	el_ex_scribble_url.tooltip = "https://github.com/JujuAdams/scribble";
	var el_ex_scribble = create_text(32 + bw + spacing, yy - 12, "[rainbow][wave]Scribble,[] a Game Maker text renderer by Juju Adams (v" + string(__SCRIBBLE_VERSION) + ", slightly customized)", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_xpanda_url = create_button(32, yy, "Github", bw, eh, fa_center, uivc_url_xpanda, dg);
	el_ex_xpanda_url.tooltip = "https://github.com/GameMakerDiscord/Xpanda/";
	var el_ex_xpanda = create_text(32 + bw + spacing, yy, "Xpanda, shader management by kraifpatrik", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_ex_regex = create_text(32, yy, "     There's a really great regex extension by Upset Baby Games, but it appears to have been delisted", ew, eh, fa_left, dw - 32, dg);
	yy += 40;

	var el_asset = create_text(32, yy, "[c_blue]Default assets", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_asset_wate_url = create_button(32, yy, "GodsAndIdols.com", bw, eh, fa_center, uivc_url_godsandidols, dg);
	el_asset_wate_url.tooltip = "www.godsandidolds.com";
	var el_asset_water = create_text(32 + bw + spacing, yy, "Water textures: Aswin Vos and GodsAndIdols", ew, eh, fa_left, dw - 32, dg);
	yy += 40;
	var el_asset_npc = create_text(32, yy, "     Default NPC: Lanea Zimmerman", ew, eh, fa_left, dw - 32, dg);
	yy += 40;

	// this is easier than resizing the dialog manually every time (up to the point where it flows off the screen)
	dh = yy + 64;
	dg.height = dh;

	var b_width = 128;
	var b_height = 32;
	var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Wow, thanks!", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents,
	    el_text,
	    el_author,
	    el_author_1, el_author_2, el_author_3, el_author_4,
	    el_help,
	    el_help_who,
	    el_ex,
	    el_ex_venomous, el_ex_venomous_url,
	    el_ex_fmod, el_ex_fmod_url,
	    el_ex_smf, el_ex_smf_url,
	    el_ex_scribble, el_ex_scribble_url,
	    el_ex_xpanda, el_ex_xpanda_url,
	    el_ex_regex,
	    el_asset,
	    el_asset_water, el_asset_wate_url,
	    el_asset_npc,
	    el_close
	);

	return dg;


}
