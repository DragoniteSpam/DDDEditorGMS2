-- if you're going to initialize anything (probably a particle system, or
-- several), you probably want to do it up at the top here

-- Required; called at the beginning of the animation, in case you want to
-- initialize anything, or anything
-- @param animation the animation which is being created - you will probably want this
function Begin(animation)
end

-- Required; called at the end of the animation, primarily to clean up anything
-- that may have been created along the way
-- @param animation the animation which is being destroyed - you will probably want this
function End(animation)
end

-- Along the way, you may want to invoke functions from keyframes on the timeline.
-- The keyframe should know the name of the function it wants to invoke, and
-- the function it calls should look like this. (no arguments taken, at least
-- not right now.)
-- @param animation the animation which is being processed
-- @param layer the layer which is being processed
-- @param keyframe the keyframe which is being processed
function Invoke(animation, layer, keyframe)
end