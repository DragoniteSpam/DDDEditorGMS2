Version 1.3

 - Added ColWorldGameMaker, which uses GameMaker instances to do the broad phase of the collision detection before using 3D collision logic to narrow down exact hits
    - This speeds up collision checks against the world by "it depends"% but in my test world there was about a 10x improvement
	- Frustum checks in dense areas can be up to about twice as expensive as quad and octrees, but are still far cheaper than rendering everything in the world at all times
		- If you have very dense environments you may want to use two structures: a ColWorldGameMaker for collisions, and a quad or octree for frustum culling
	- You can only have one ColWorldGameMaker at once, as instances are not filtered for which world they belong to for performance reasons
 - 50% of ColObject/ColObject checks no longer result in an additional indirect method call
 - Optimized AABB/OBB by like 40%
    - This also means good things for OBB/trimesh
 - Optimized trimesh/everything by "it depends"%
    - You still shouldn't use these if you don't have to
 - Dropped support for anything older than 2024.14, so that we can take full advantage of a variety of new optimizations that were added then
    - Native matrix_inverse without a fallback solution
    - Native sphere visiblity checks are much faster than the ones we did ourselves
    - A bunch of the matrix functions can now take an output array so we don't have to re-allocate a bunch of other arrays

Version 1.2

 - Added an bonus GetObjectsInFrustumFast() method which uses the native sphere_is_visible() function added in 2024.1400 betas
    - In my testing it runs in about half the time as the original
    - This might become the default version eventually, unless I find something wrong with it

Version 1.1

 - A bunch of optimizations
 - A whole bunch of new `Vector` functions (including a Vector2 class), just for fun
 - Removed the Matrix classes in favor of just using the GameMaker 16-element array matrices, because those were confusing and using them added more overhead that I really like
 - If you construct a ColTransformedModel (or call the Set() method that goes with them) with an array of ColTriangles instead of a ColMesh, a ColMesh will be created for you
     - This will create a new ColMesh from scratch, so only do this if each Transformed Model is to be associated with a unique Mesh
 - ColWorld now takes an Octree, **Quadtree**, or _Spatial Hash_ as its preferred acceleration structure instead of creating one for you
 - ColWorld::CheckRay can now take a maximum distance, discarding any hits that are farther away
 - Added `COL_MIN_TREE_DENSITY` to set the object threshold for when a tree structure is subdivided, which can speed them up by a fair amount
 - Shapes attached to objects also have an .object reference that they can refer back to

[click here for the answer to life, the universe, and everything](https://www.youtube.com/watch?v=dQw4w9WgXcQ)

Version 1.0

 - Initial release