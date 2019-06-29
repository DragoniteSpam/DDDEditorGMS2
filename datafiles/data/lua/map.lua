-- Not required, but recommended so that you can keep track of the currently
-- active AudioGroup
group = -1

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
end

-- Required; called once when the map is exited
-- @param map the map, which you are allowed to get (and set) the properties of
-- @param t the number of seconds since Game Start
function Exit(map, t)
end