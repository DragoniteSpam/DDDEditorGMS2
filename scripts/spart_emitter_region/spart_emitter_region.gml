/// @description spart_emitter_region(ind, orientationMatrix[16], xscale, yscale, zscale, shape, distribution, dynamic)
/// @param ind
/// @param orientationMatrix[16]
/// @param xscale
/// @param yscale
/// @param zscale
/// @param shape
/// @param distribution
/// @param dynamic
function spart_emitter_region(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	/*
		Change the orientation, scale, shape and distribution of the emitter.
		Set dynamic to true if you'd like the particles that have already been created
		to finish drawing with the old settings.
	
		orientationMatrix must be a matrix WITHOUT SCALING. This is important!
		Scaling must be supplied on its own in the next three arguments.
		You can build an orientation matrix like this:
		matrix_build(x, y, z, xrot, yrot, zrot, 1, 1, 1);

		You can use the following constants for shape:
		spart_shape_circle
		spart_shape_cube
		spart_shape_sphere
		spart_shape_cylinder

		You can use the following constants for distribution:
		ps_distr_linear
		ps_distr_gaussian <-- Not actually gaussian at this time, but something that resembles it
		ps_distr_invgaussian <-- Not actually inverse gaussian at this time, but something that resembles it

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = argument0;
	var M = argument1;
	var xScale = argument2;
	var yScale = argument3;
	var zScale = argument4;
	var shape = argument5;
	var distribution = argument6;
	var dynamic = argument7;
	var partSystem = partEmitter[| sPartEmt.PartSystem];

	//Modify the matrix
	var l1 = M[0] * M[0] + M[1] * M[1] + M[2] * M[2];
	var l2 = M[4] * M[4] + M[5] * M[5] + M[6] * M[6];
	var l3 = M[8] * M[8] + M[9] * M[9] + M[10] * M[10];
	if (min(l1, l2, l3) <= math_get_epsilon())
	{
		show_debug_message("Error in script spart_emitter_region: You've supplied a matrix that has been scaled improperly. See script comments for more info.");
		exit;
	}
	if abs(xScale < .01){xScale = 0.01;}
	if abs(yScale < .01){yScale = 0.01;}
	if abs(zScale < .01){zScale = 0.01;}
	if (l1 != 1){xScale /= sqrt(l1);}
	if (l2 != 1){yScale /= sqrt(l2);}
	if (l3 != 1){zScale /= sqrt(l3);}
	M[0] *= xScale;
	M[1] *= xScale;
	M[2] *= xScale;
	M[4] *= yScale;
	M[5] *= yScale;
	M[6] *= yScale;
	M[8] *= zScale;
	M[9] *= zScale;
	M[10] *= zScale;

	//If dynamic change is activated, the old emitter is retired, and will live on until it dies
	if dynamic
	{
		if spart_emitter_retire(partEmitter, false)
		{
			partEmitter[| sPartEmt.CreationTime] = partSystem[| sPartSys.Time];
			partEmitter[| sPartEmt.StartMat] = partEmitter[| sPartEmt.EndMat];
			partEmitter[| sPartEmt.ID] = irandom(256 * 256);
		}
	}
	else
	{
		partEmitter[| sPartEmt.StartMat] = M;
	}
	partEmitter[| sPartEmt.EndMat] = M;
	partEmitter[| sPartEmt.Shape] = shape;
	partEmitter[| sPartEmt.Distribution] = distribution;
	spart__emitter_activate(partEmitter);


}
