-- Not required, but recommended so that you can keep track of the currently
-- active AudioGroup
audio_group = -1

-- Required; called once per second when the game checks to see if anything
-- should change on the map (weather, effects, audio, etc).
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function Update(map, t)
end

-- Required; called once when the map is entered
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function Enter(map, t)
    BeginMusic(map, t)
end

-- Required; called once when the map is exited
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function Exit(map, t)
end

-- Required; called any time the music will be started
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function BeginMusic(map, t)
end

-- Not required, but recommended; determines random encounters for different
-- regions on the map. If you want different encounter types you will likely
-- want similar functions whose names begin with "EvalEncounter".
-- @param h the current time of day, in hours; you may want different encounters
--      based on the time of day
-- @param weather the current weather; you may want different encounters
--      based on the current weather
function EvalEncounterMain(h, weather)
    return noone
end

 -- Returns the total of the encounter weights - this will probably be helpful
 -- to have, and possibly override
 -- @param zone the zone to calculate the total weight of
function ZoneTotalWeight(zone)
    return 0
end