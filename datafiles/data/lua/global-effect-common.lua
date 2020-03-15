-- Any effect update functions you define should take the form of these;
-- DDD will automatically call the "Update," etc versions of the functions
-- at the appropriate times

-- This is called when the effect is loaded into a map
-- @param component The component which this code is being used on
-- @param t The amount of time since the game has started, in seconds
function SampleCreate(component, t)
end

-- This is called when the effect is unloaded from a map
-- @param component The component which this code is being used on
-- @param t The amount of time since the game has started, in seconds
-- @param dt The delta time value, in seconds
function SampleDestroy(component, t)
end

-- This is called in each frame
-- @param component The component which this code is being used on
-- @param t The amount of time since the game has started, in seconds
-- @param dt The delta time value, in seconds
function SampleUpdate(component, t, dt)
end