# DDDEditorGMS2

[![Made with GameMaker Studio 2](https://img.shields.io/badge/Made%20with-GameMaker_Studio_2-000000.svg?style=flat&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAZlBMVEX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2BrG8stAAAAIXRSTlMABg0OFBkfcn1%2Bf4CBgoOFhoeIiouWmNDa5ebp8PX2%2B%2F6o6Vq%2BAAAAY0lEQVR42k2OWQ6AIAwFn%2BIOioobrnD%2FS4o0EeanmQxNAdErRFTWtsFq6%2BiiZozz0CSnTjYBwo0RkF8DWDLf51Ni9K%2FYdq0Fy3KAfzk97M7goK1F%2F4rGH9Kk1OlboQtEDIrmC%2BU3CVxTr%2FRMAAAAAElFTkSuQmCC)](https://www.yoyogames.com/gamemaker)

I have it in my head that making a general-purpose game editor will save me time in the long run, as opposed to falling into the trap of [this](https://xkcd.com/1319/), which it almost certainly already has. But on the other hand, I've had fun working on this, so maybe that's okay.

(With that said, it's bee nice having this base of code to use as a starting point to spin other tools off of.)

The design of this editor borrows a lot from RPG Maker, although there are a number of places where it obviously deviates - all events are functionally Common Events - and some stuff that's totally new, such as 3D meshes.

By the way I'm chronically behind on updating this readme, I hope you understand.

## Media

The main game editor: you can slap down entities of different types (characters, tiles, models, some other things). You can modify their properties, give them behaviors and some other things. (Click to expand the images.)

<img src="https://i.imgur.com/q13XVAf.png" width="160">

There's also a 2D mode if you're into that kind of thing, although the underling code is almost exactly the same.

<img src="https://i.imgur.com/P4HbuZy.png" width="160">

Game data types can be created. Some generic stuff like "sound effects and music" is built-in, but anything that's specific to your particular game has to be defined first.

<img src="https://i.imgur.com/97yrhiI.png" width="160">

Once the custom data types are defined, you can assign values to them.

<img src="https://i.imgur.com/SXZzsqJ.png" width="160">

And then there's the event editor. It's essentially just a nodal version of the RPG Maker event editor. It took a lot of work to make but it works pretty well, and I'm happy with how it came out.

<img src="https://i.imgur.com/vkEd3kt.png" width="160">

There are some miscellaneous property editor form UI things.

<img src="https://i.imgur.com/3Eqfov7.png" width="160">

A long time ago I made a 3D terrain editor for Game Maker. Several of them, in fact. It's not directly related to the rest of DDD but it uses a lot of the same code, the renderer, etc so when someone asked me to re-make it recently I decided to include it.

<img src="https://i.imgur.com/cKyAlOY.png" width="160">

## Upcoming stuff

 - Overhauling the save structure, giving more control over how (and what) gets saved and enabling data files to be swapped around more easily
 - Autotiles (for both 2D tiles and 3D meshes)
 - More map stuff, especially verticality
 - Certain data structures inside the editor are garbage so i'm going to spend a bit of time refactoring
 - Off-grid map editing (both in 2D and in 3D) - although the main grid-based functionality will obviously take priority

## Stuff I'm considering adding

Obviously I want to fully implement and / or expand a lot of the things that are already included, but there are also a few completely new things that I want to get to eventually that aren't part of the program yet.

 - UI blueprints: they won't be fully scriptable or anything, but they should make laying out menus and whatnot in-game easier than they otherwise would be
 - Proper documentation (beyond the tooltips)

## How development for this works

For the time being, I'm compiling updates once a week or so, or perhaps more often if I find a bug that breaks things entirely. If I don't have much to add at the end of a given week I might skip one, or if I finish off something major I might release it as soon as it's done. The versioning system I'll be using goes `year.quarter.release.build`, so `2019.4.3.22` would be the third release in the fourth quarter of 2019, and the twenty-second time overall I created an executable.

Unless something seriously bad happens and I'm not able to make the Yoyo Compiler work, there will be two versions: one with the regular Game Maker interpreter ("default"), and one made from the Yoyo Compiler ("YYC"). The interpreted version will be somewhat slower but should be more stable, and the YYC version will be faster but potentially buggier.

I've learned the hard way that having large amounts of bad code inevitably makes it really hard to develop a project, which means I refactor things fairly frequently. As a result, things that used to work break from time to time. If you're using this, that means you want to save your work and make backups frequently, and as a general rule verison control is never a bad thing.

In addition, the data format evolves over time. For the most part the editor is backwards compatible and will be quite happy to read old version of the data files, but to fend off the aforementioned code rot I kill off old versions periodically (now that I'm publishing releases, I'll probably be doing that once a quarter or so). I'll say when I put out an update that kills compatibility, and if you try to load an old data file the editor will tell you and ask you to save it through a more recent version that it will accept.

## Usage

The game I'm making in tandem with this editor (and using this editor) is currently in a private repository so you can't look at that to see how you use the data files, although the `serialize_load_*` scripts should give you a good idea of how the data's stored. Except for game maps and a few places where a number of related bools are smashed together into an int32 it's mostly just a bunch of data types stored in sequence.

### Contributors

 - [DragoniteSpam](https://github.com/DragoniteSpam)
 - [RatcheT2498](https://github.com/RatcheT2497)

### Original project

The original GMS1 repository can be found [here](https://github.com/DragoniteSpam/DDDEditor), but I won't be updating it in the future because GMS2 is really good and I don't plan on going back.
