/// @description spart__tri_in_cube(tri[12], boxhalfSize, boxCenterX, boxCenterY, boxCenterZ)
/// @param tri[12]
/// @param boxhalfSize
/// @param boxCenterX
/// @param boxCenterY
/// @param boxCenterZ
function spart__tri_in_cube() {

	/********************************************************/
	/* AABB-triangle overlap test code                      */
	/* by Tomas Akenine-Möller                              */
	/* Function: int triBoxOverlap(float boxcenter[3],      */
	/*          float boxhalfsize[3],float tri[3][3]); */
	/* History:                                             */
	/*   2001-03-05: released the code in its first version */
	/*   2001-06-18: changed the order of the tests, faster */
	/*                                                      */
	/* Acknowledgement: Many thanks to Pierre Terdiman for  */
	/* suggestions and discussions on how to optimize code. */
	/* Thanks to David Hunt for finding a ">="-bug!         */
	/********************************************************/
	/*    
	Use separating axis theorem to test overlap between triangle and box
	need to test for overlap in these directions:
	1) the {x,y,z}-directions (actually, since we use the AABB of the triangle we do not even need to test these)
	2) normal of the triangle
	3) crossproduct(edge from tri, {x,y,z}-directin)
	this gives 3x3=9 more tests 
	*/

	var bX, bY, bZ, hsize, tri;
	tri = argument[0];
	hsize = argument[1];
	bX = argument[2];
	bY = argument[3];
	bZ = argument[4];

	/* Bullet 1: */
	/*  first test overlap in the {x,y,z}-directions */
	/*  find min, max of the triangle each direction, and test for overlap in */
	/*  that direction -- this is equivalent to testing a minimal AABB around */
	/*  the triangle against the AABB */

	/* test in X-direction */
	var v0x, v1x, v2x;
	v0x = tri[0] - bX;
	v1x = tri[3] - bX;
	v2x = tri[6] - bX;
	if (min(v0x, v1x, v2x) > hsize || max(v0x, v1x, v2x) < -hsize){return false;}

	/* test in Y-direction */
	var v0y, v1y, v2y;
	v0y = tri[1] - bY;
	v1y = tri[4] - bY;
	v2y = tri[7] - bY;
	if (min(v0y, v1y, v2y) > hsize || max(v0y, v1y, v2y) < -hsize){return false;}

	/* test in Z-direction */
	var v0z, v1z, v2z;
	v0z = tri[2] - bZ;
	v1z = tri[5] - bZ;
	v2z = tri[8] - bZ;
	if (min(v0z, v1z, v2z) > hsize || max(v0z, v1z, v2z) < -hsize){return false;}

	/* Bullet 2: */
	/*  test if the box intersects the plane of the triangle */
	/*  compute plane equation of triangle: normal*x+d=0 */
	//CROSS(normal,e0,e1);
	var nx, ny, nz, d;
	nx = tri[9];
	ny = tri[10];
	nz = tri[11];
	d = dot_product_3d(nx, ny, nz, v0x, v0y, v0z);

	var minx, maxx, miny, maxy, minz, maxz;
	if (nx > 0){
		minx = -hsize;
		maxx = hsize;}
	else{
		minx = hsize;
		maxx = -hsize;}
	if (ny > 0){
		miny = -hsize;
		maxy = hsize;}
	else{
		miny = hsize;
		maxy = -hsize;}
	if (nz > 0){
		minz = -hsize;
		maxz = hsize;}
	else{
		minz = hsize;
		maxz = -hsize;}

	if (dot_product_3d(nx, ny, nz, minx, miny, minz) > d){return false;}
	if (dot_product_3d(nx, ny, nz, maxx, maxy, maxz) < d){return false;}

	/* Bullet 3:  */
	var fex, fey, fez, p0, p1, p2, ex, ey, ez, rad;
	ex = v1x - v0x;
	ey = v1y - v0y;
	ez = v1z - v0z;
	fex = abs(ex) * hsize;
	fey = abs(ey) * hsize;
	fez = abs(ez) * hsize;
   
	p0 = ez * v0y - ey * v0z;
	p2 = ez * v2y - ey * v2z;
	rad = fez + fey;
	if (min(p0, p2) > rad || max(p0, p2) < -rad){return false;}
   
	p0 = -ez * v0x + ex * v0z;
	p2 = -ez * v2x + ex * v2z;
	rad = fez + fex;
	if (min(p0, p2) > rad || max(p0, p2) < -rad){return false;}
           
	p1 = ey * v1x - ex * v1y;                 
	p2 = ey * v2x - ex * v2y;                 
	rad = fey + fex;
	if (min(p1, p2) > rad || max(p1, p2) < -rad){return false;}

	ex = v2x - v1x;
	ey = v2y - v1y;
	ez = v2z - v1z;
	fex = abs(ex) * hsize;
	fey = abs(ey) * hsize;
	fez = abs(ez) * hsize;
	      
	p0 = ez * v0y - ey * v0z;
	p2 = ez * v2y - ey * v2z;
	rad = fez + fey;
	if (min(p0, p2) > rad || max(p0, p2) < -rad){return false;}
          
	p0 = -ez * v0x + ex * v0z;
	p2 = -ez * v2x + ex * v2z;
	rad = fez + fex;
	if (min(p0, p2) > rad || max(p0, p2) < -rad){return false;}
	
	p0 = ey * v0x - ex * v0y;
	p1 = ey * v1x - ex * v1y;
	rad = fey + fex;
	if (min(p0, p1) > rad || max(p0, p1) < -rad){return false;}

	ex = v0x - v2x;
	ey = v0y - v2y;
	ez = v0z - v2z;
	fex = abs(ex) * hsize;
	fey = abs(ey) * hsize;
	fez = abs(ez) * hsize;

	p0 = ez * v0y - ey * v0z;
	p1 = ez * v1y - ey * v1z;
	rad = fez + fey;
	if (min(p0, p1) > rad || max(p0, p1) < -rad){return false;}

	p0 = -ez * v0x + ex * v0z;
	p1 = -ez * v1x + ex * v1z;
	rad = fez + fex;
	if (min(p0, p1) > rad || max(p0, p1) < -rad){return false;}
	
	p1 = ey * v1x - ex * v1y;
	p2 = ey * v2x - ex * v2y;
	rad = fey + fex;
	if (min(p1, p2) > rad || max(p1, p2) < -rad){return false;}

	return true;


}
