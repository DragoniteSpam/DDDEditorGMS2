event_inherited();

/*
 * * * * * * * * * * * * * * * * * *
 *                 * AT0    AT8    *
 *                 * AT1    AT9    *
 *       Map       * AT2    AT10   *
 *      Tiles      * AT3    AT11   *
 *                 * AT4    AT12   *
 *                 * AT5    AT13   *
 *                 * AT6    AT14   *
 * * * * * * * * * * AT7    AT15   *
 *                                 *
 *                                 *
 *                                 *
 *                                 *
 *                                 *
 *                                 *
 *                                 *
 * * * * * * * * * * * * * * * * * *
 */

// this should only be instantiated in tileset_create so don't worry
// about populating the values right now
picture_name="";
picture=-1;
autotiles=array_create(AUTOTILE_MAX);
array_clear(autotiles, noone);

autotile_positions=array_create(AUTOTILE_MAX);
autotile_sizes=array_create(AUTOTILE_MAX);
for (var i=0; i<AUTOTILE_MAX; i++){
    autotile_positions[i]=vector2(0.5+(i div (AUTOTILE_MAX/2))*0.25, (i mod (AUTOTILE_MAX/2))/16);
    autotile_sizes[i]=vector2(32/TEXTURE_SIZE, 32/TEXTURE_SIZE);
}

// the main picture and all of the autotiles are stored on here
master=noone;

passage=noone;
priority=noone;
flags=noone;
tags=noone;

at_passage=noone;
at_priority=noone;
at_flags=noone;
at_tags=noone;

enum TilePassability {
    UP=1<<0,
    DOWN=1<<1,
    LEFT=1<<2,
    RIGHT=1<<3
}

enum TileFlags {
    BUSH=1<<0,
    COUNTER=1<<1,
}

enum TileTerrainTags {
    NONE,               /*00*/
    LEDGE,              /*01*/
    GRASS,              /*02*/
    SAND,               /*03*/
    ROCK,               /*04*/
    DEEPWATER,          /*05*/
    STILLWATER,         /*06*/
    WATER,              /*07*/
    WATERFALL,          /*08*/
    WATERFALLCREST,     /*09*/
    TALLGRASS,          /*10*/
    UNDERWATERGRASS,    /*11*/
    ICE,                /*12*/
    NEUTRAL,            /*13*/
    SOOTGRASS,          /*14*/
    BRIDGE,             /*15*/
    FINAL       // this is not for anything just modulo division
}

// this technically will get redefined every time you create a new tileset
// which is a total waste of time but hopefully that doesn't happen too
// often, so i won't bother to put it somewhere more logical
globalvar all_tile_terrain_tag_names;

all_tile_terrain_tag_names=["None",
    "Ledge",
    "Grass",
    "Sand",
    "Rock",
    "Deep Water",
    "StilL Water",
    "Water",
    "Waterfall",
    "Waterfall Crest",
    "Tall Grass",
    "Underwater Grass",
    "Ice",
    "Neutral",
    "Soot Grass",
    "Bridge"];

enum AutotileSegments {
    SURROUNDED,     /*00*/
    CLEAR,          /*01*/
    INVERSE,        /*02*/
    UPPER_LEFT,     /*03*/
    UPPER,          /*04*/
    UPPER_RIGHT,    /*05*/
    LEFT,           /*06*/
    CENTER,         /*07*/
    RIGHT,          /*08*/
    LOWER_LEFT,     /*09*/
    LOWER,          /*10*/
    LOWER_RIGHT     /*11*/
}

/* */
/*  */
