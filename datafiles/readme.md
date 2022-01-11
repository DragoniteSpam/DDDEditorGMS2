Hello, this is the beta for a major update for this here terrain editor.

Here's a list of change and additions from the last version. Items marked with an * are still a work in progress:

## Functionality

 - The whole thing is much, much faster in pretty much all regards
 - Certain tasks that used to be done in GML are now executed by a DLL, courtesy of C++*

#### Import/export

 - Less buggy heightmap import/export?
 - Export a vertex buffer directly
 - Many, many export options have been added:
   - Multiple LOD levels, with the settings for the number of LOD levels and the reduction factor
   - Smooth normals on export
   - Split the terrain up into chunks (this works very well with LODs)
   - Customize the vertex format*

#### General editing

 - Max terrain size is now 2048x2048 - I don't really recommend this though, because DLL or not this will still be rather slow*
 - Mutate the terrain based on Perlin noise*
 - Mutate the terrain based on a heightmap*
 - Brushes for painting on the terrain*

## Visuals

 - There's a real pretty skybox
 - Better water shader
 - The UI is a bit less awkward overall
 - Draw a wireframe on the terrain

## Other stuff

 - A metric buttload of internal changes, optimizations, and bug fixes

## WIP items and known issues

You probably want to know about some of the things that are incomplete, or some of the features from the last version that are (currently) not available in the beta.

 - Documentation: there currently is none, but we've reached the point where there really, really should be

 - Perlin noise generation/mutation will produce strange results on terrains that are not powers of 2. There's a small oversight in my noise generation code that I'll fix eventually, although most of you are probably going to make power-of-two terrains anyway so it's not a top priority

 - Project save and load: it'd be super helpful to be able to come back to a project later, instead of executing a one-way export and being done with it. (The only reason it's not already included is because if the terrain data changes as I continue working on this, I don't want existing save files to need a messy conversion process.)
 - Import/export: currently only 3D Position, Face Normal, and  Barycentric Coordinate actually do anything. The other attributes will resolve to 0, or (in the case of colo(u)r) c_white
 - Editing: there are still some things I can probably do to make the program even faster for editing, and support even larger terrain sizes
 - Editing/mutation: more terrain deformation options, and some streamlining of the editing tools
 - Editing/mutation: more stock heightmaps will be added, and eventually I'm going to add the ability to import your own heightmap for the purpose of modifying the terrain instead of only creating a new terrain
 - Editing: allow the user to enter a seed for the random number generation
 - Editing: use different brush shapes for terrain deformation and texture setting, the same as terrain painting
 - Lighting: settings not yet implemented, aside from the default light
 - Texture: settings not yet implemented; I'm still undecided on what the best way to handle this will be, but getting it in will be a priority
 - View: 2D orthographic view - this might not come back because I'm currently unconvinced of its utility
 - View: shadowmapping is fun, I want to add it eventually

## Bug reporting

I've probably found and dealt with some of the more common issues, but if an error message ever shows up let me know what it says and how you did it. (Screenshots and video help.)

There are some times when the program may hang for a few seconds (especially when doing operations on large terrains, such as normal smoothing), but as long as it doesn't crash outright things should be okay.