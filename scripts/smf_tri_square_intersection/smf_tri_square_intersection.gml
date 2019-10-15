/// @description smf_tri_square_intersection(boxCenterX, boxCenterY, boxhalfW, boxhalfL, triVerts[9])
/// @param boxCenterX
/// @param boxCenterY
/// @param boxCenterZ
/// @param boxhalfW
/// @param boxhalfL
/// @param boxhalfH
/// @param triVerts[9]

/********************************************************/
/* AABB-triangle overlap test code                      */
/* by Tomas Akenine-Möller                              */
/* Function: int triBoxOverlap(float boxcenter[3],      */
/*          float boxhalfsize[3],float triverts[3][3]); */
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
gml_pragma("forceinline");

var boxCenter, boxhalfsize, triVerts;
boxCenter = [argument0, argument1];
boxhalfsize = [argument2, argument3];
triVerts = argument4;

var fe, p0, p1, p2;
var rad, Min, Max, normal, vmin, vmax, d;
var v0, v1, v2;
v0 = [triVerts[0] - boxCenter[0], triVerts[1] - boxCenter[1]];
v1 = [triVerts[3] - boxCenter[0], triVerts[4] - boxCenter[1]];
v2 = [triVerts[6] - boxCenter[0], triVerts[7] - boxCenter[1]];

/* compute triangle edges */
var e0, e1, e2;
e0 = [v1[0] - v0[0], v1[1] - v0[1]];
e1 = [v2[0] - v1[0], v2[1] - v1[1]];
e2 = [v0[0] - v2[0], v0[1] - v2[1]];

/* Bullet 3:  */
/*  test the 9 tests first (this was faster) */
fe = [abs(e0[0]), abs(e0[1])];
           
p1 = e0[1]*v1[0] - e0[0]*v1[1];                 
p2 = e0[1]*v2[0] - e0[0]*v2[1];                 
rad = fe[1] * boxhalfsize[0] + fe[0] * boxhalfsize[1];
if(min(p1, p2) > rad || max(p1, p2) <- rad) return 0;

fe = [abs(e1[0]), abs(e1[1])];
	
p0 = e1[1]*v0[0] - e1[0]*v0[1];
p1 = e1[1]*v1[0] - e1[0]*v1[1];
rad = fe[1] * boxhalfsize[0] + fe[0] * boxhalfsize[1];
if(min(p0, p1) > rad || max(p0, p1) <- rad) return 0;

fe = [abs(e2[0]), abs(e2[1])];
	
p1 = e2[1]*v1[0] - e2[0]*v1[1];
p2 = e2[1]*v2[0] - e2[0]*v2[1];
rad = fe[1] * boxhalfsize[0] + fe[0] * boxhalfsize[1];
if(min(p1, p2) > rad || max(p1, p2) <- rad) return 0;

/* Bullet 1: */
/*  first test overlap in the {x,y,z}-directions */
/*  find min, max of the triangle each direction, and test for overlap in */
/*  that direction -- this is equivalent to testing a minimal AABB around */
/*  the triangle against the AABB */

/* test in X-direction */
if(min(v0[0], v1[0], v2[0]) > boxhalfsize[0] || max(v0[0], v1[0], v2[0]) < -boxhalfsize[0]) return 0;

/* test in Y-direction */
if(min(v0[1], v1[1], v2[1]) > boxhalfsize[1] || max(v0[1], v1[1], v2[1]) < -boxhalfsize[1]) return 0;

/* Bullet 2: */
/*  test if the box intersects the plane of the triangle */
/*  compute plane equation of triangle: normal*x+d=0 */
//CROSS(normal,e0,e1);
return 1;