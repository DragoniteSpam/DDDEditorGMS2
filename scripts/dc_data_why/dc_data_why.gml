/// @description void dc_data_why(UIButton);
/// @param UIButton
function dc_data_why(argument0) {

	var dw=400;
	var dh=360;

	var dg=dialog_create(dw, dh, "this is work", dialog_default, dc_close_no_questions_asked, argument0);

	var b_width=128;
	var b_height=32;

	var el_text=create_text(dw/2, dh*2/5, "I could manually check every existing game variable and ask you how you want to resolve any conflicts that may appear, but that takes a lot of development time and I need to finish this before never. You can still accuse me of being lazy and incompetent on Twitter though, my feelings probably won't be hurt.", 0, 0, fa_center, dw-96, dg);
	var el_ok=create_button(dw/2-b_width/2, dh-32-b_height/2, "okay cool", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents, el_text, el_ok);



}
