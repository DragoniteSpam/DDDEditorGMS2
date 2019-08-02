-- if you're going to initialize anything (probably a particle system, or
-- several), you probably want to do it up at the top here

-- Required; called at the beginning of the animation, in case you want to
-- initialize anything, or anything
-- @param data extra data about the animation that may get passed in (may be null)
function Begin(data)
end

-- Required; called at the end of the animation, primarily to clean up anything
-- that may have been created along the way
function End()
end

-- Along the way, you may want to invoke functions from keyframes on the timeline.
-- The keyframe should know the name of the function it wants to invoke, and
-- the function it calls should look like this. (no arguments taken, at least
-- not right now.)
function Invoke()
end