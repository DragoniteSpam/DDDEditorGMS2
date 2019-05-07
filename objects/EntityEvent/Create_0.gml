event_inherited();

name="Event";
etype=ETypes.ENTITY_EVENT;

ActiveMap.population[ETypes.ENTITY_EVENT]++;

// no save/load script here yet

// editor properties

slot=MapCellContents.EVENT;
batchable=false;

// there will be other things down here probably
on_select=safc_on_event;

