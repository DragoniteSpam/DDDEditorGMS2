event_inherited();

/*
 * * * * * * * * * * AT00 * * AT16 * *
 *                 * AT00     AT17   *
 *                 * AT01     AT18   *
 *       Map       * AT02     AT19   *
 *      Tiles      * AT03     AT20   *
 *                 * AT04     AT21   *
 *                 * AT05     AT22   *
 *                 * AT06     AT23   *
 * * * * * * * * * * AT07     AT24   *
 *                   AT08     AT25   *
 *                   AT09     AT26   *
 *                   AT10     AT27   *
 *                   AT11     AT28   *
 *                   AT12     AT29   *
 *                   AT13     AT30   *
 *                   AT14     AT31   *
 *                   AT15     AT32   *
 * * * * * * * * * * * * * * * * * * *
 */

// filename
picture_name = "";
// the entire image is stored here
master = -1;

// these are just the indices, the actual autotiles are stored in Stuff
autotiles = array_create(AUTOTILE_MAX);
array_clear(autotiles, noone);

passage = noone;
priority = noone;
flags = noone;
tags = noone;

at_passage = noone;
at_priority = noone;
at_flags = noone;
at_tags = noone;

enum TilePassability {
    UP = 1 << 0,
    DOWN = 1 << 1,
    LEFT = 1 << 2,
    RIGHT = 1 << 3
}

enum TileFlags {
    BUSH = 1 << 0,      /* bush animation(?) */
    COUNTER = 1 << 1,   /* counter */
    SAFER = 1 << 2,     /* reduced encounter rate */
    DANGER = 1 << 3,    /* increased encounter rate */
}

enum TileTerrainTags {
    NONE,               /* 00 */
    LEDGE,              /* 01 */
    GRASS,              /* 02 */
    SAND,               /* 03 */
    ROCK,               /* 04 */
    DEEPWATER,          /* 05 */
    STILLWATER,         /* 06 */
    WATER,              /* 07 */
    WATERFALL,          /* 08 */
    WATERFALLCREST,     /* 09 */
    TALLGRASS,          /* 10 */
    UNDERWATERGRASS,    /* 11 */
    ICE,                /* 12 */
    NEUTRAL,            /* 13 */
    SOOTGRASS,          /* 14 */
    BRIDGE,             /* 15 */
    FINAL
}

// this used to be global but now if you want to define different tags for each tileset,
// you're allowed
terrain_tag_names = ds_list_create();
ds_list_add(terrain_tag_names,
    "None", "Ledge", "Grass", "Sand", "Rock", "Deep Water",
    "StilL Water", "Water", "Waterfall", "Waterfall Crest", "Tall Grass",
    "Underwater Grass", "Ice", "Neutral", "Soot Grass", "Bridge"
);