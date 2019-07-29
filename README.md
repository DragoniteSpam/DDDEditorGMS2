# DDDEditorGMS2
Migrating to GMS2, or attempting to

The original GMS1 project can be found [here](https://github.com/DragoniteSpam/DDDEditor), but I probably won't be updating it a whole lot after this

### Contributors
 - DragoniteSpam
 - RatcheT2498

## Media

The main game editor: you can slap down entities of different types (characters, tiles, models, some other things). You can modify their properties, give them behaviors and some other things. (Click to expand the images.)

![Main game editor](https://i.imgur.com/q13XVAf.png | height = 160)

Game data types can be created. Some generic stuff like "sound effects and music" is built-in, but game-specific things have to be defined in the editor first.

![Define data types](https://i.imgur.com/97yrhiI.png | height = 160)

And then you can assign values to them.

![Edit data types](https://i.imgur.com/SXZzsqJ.png | height = 160)

And then there's the event editor. It's essentially just a nodal version of the RPG Maker event editor. It took a lot of work to make but it works pretty well, and I'm happy with how it came out.

![Event editor](https://i.imgur.com/vkEd3kt.png | height = 160)

There are some miscellaneous property editor form UI things.

![I guess?](https://i.imgur.com/3Eqfov7.png | height = 160)

## Upcoming stuff

 - Animation editor - for battle attacks and world effects and whatnot
 - Autotiles (for both 2D tiles and 3D meshes)
 - More map stuff, verticality, camera controls

## Stuff I'm considering

 - - Animated meshes (I won't be doing this myself but I know some people who have who I may ask)
 - UI blueprints
 - 2D mode for maps / game

### Original readme:
Game data editor to go along with [DoOrDieDragonite](https://github.com/DragoniteSpam/PokemonDoOrDie).

The plan is to create a fully-featured game editor that will be able to handle all of the information that the main game stores externally, such as maps, monster data, item data, and probably a bunch of other stuff. The map editor portion is going to take priority for the time being though.

#### Known Issues

 - **Semi-transparency in 3D space** - if you try to draw surface underneath an existing semi-transparent surface, it won't work. This is a Game Maker-wide problem and I'll probably either deal with depth sorting later, or just get rid of semi-transparent textures.
 
 - **Deleting custom data types and their properties** - edge cases, that is all
