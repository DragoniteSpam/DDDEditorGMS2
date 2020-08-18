/// @description smf_path_draw(path)
/// @param path
function smf_path_draw() {
	/*
	var a, b, c, A, B, C, _x, _y, _z, amount;
	var pth = argument0;
	var closed = smf_path_get_closed(pth);
	var pthNum = smf_path_get_number(pth);
	if pthNum == 0{exit;}

	vertex_begin(SMF_pathModel, SMF_wireframe);
	for (var i = 0; i <= pthNum; i ++)
	{
	    if closed
	    {
	        b = floor(i) mod pthNum;
	    }
	    else
	    {
	        b = min(floor(i), pthNum - 1);
	    }
	    B = smf_path_get_point(pth, b);
	    _x = B[SMF_X];
	    _y = B[SMF_Y];
	    _z = B[SMF_Z];
    
	    vertex_position_3d(SMF_pathModel, _x, _y, _z);
	}
	vertex_end(SMF_pathModel);
	shader_set(sh_wireframe);
	vertex_submit(SMF_pathModel, pr_linestrip, -1);
	shader_reset();

/* end smf_path_draw */
}
