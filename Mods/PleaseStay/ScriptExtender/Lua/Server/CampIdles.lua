
------------------------------------------------------------------------------------------------------------------------------
--
--
--                                         For handling playing camp idles
--
--
---------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------


--------------------------------------------------------------
--
--                           METHODS
--
--------------------------------------------------------------

-- Helpers
--------------------------------------------------------------

-- Returns whether a character has the "Play Animations" status active
--@param  uuid string
--@return bool
function HasIdleStatus(uuid)
    if Osi.HasActiveStatus(uuid, "PLEASESTAY_PLAY_ANIMATIONS_STATUS") == 1 then
        return true 
    else
        return false
    end
end


-- Returns the allowed animations for a character (based on whether they are an Origin, bodytype [and maybe race - waiting for test results])
local function getAllowedAnimations(character)
    -- General works for everyone. Origins get their special ones + general
    -- Everyone else gets General

    local allowedAnimations
    local generics = ANIMATIONS["any"]

    for uuid, animationList in pairs(ANIMATIONS) do
        if uuid == character then
            allowedAnimations = Concat(generics, animationList)
        end
    end

    -- Tavs etc
    if allowedAnimations == nil then
        allowedAnimations = generics
    end

    return allowedAnimations

end

-- Toggling
--------------------------------------------------------------


-- untoggles the Stay Still passive for every entity that has it toggled on
function untoggleAnimationEveryone()
    for _, uuid in pairs(GetEveryoneThatIsRelevant())do
        if HasIdleStatus(uuid) then
            Osi.TogglePassive(uuid, "PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
        end
    end
end


-- Playing Animations
--------------------------------------------------------------

-- plays idle animations for a character every few seconds
--@param character string
function startPlayingIdleAnims(character)

    if HasIdleStatus(character) and (not (character == Osi.GetHostCharacter())) then
        animations = getAllowedAnimations(character)
        local i = math.random(#animations)
        local animation =  animations[i]
        pcall(Osi.PlayAnimation, character,  animation)

    end
      -- Call same function again after 40 min (makes sure all anims finish)
      Osi.ObjectTimerLaunch(character, "StartedPlayingAnimation",40000)
end


-- Initializing
-----------------------------------------------------------------

local function onLevelGameplayStarted()
    -- resume idle animations 
    for _, uuid in pairs(GetEveryoneThatIsRelevant()) do
        startPlayingIdleAnims(CleanPrefix(uuid))
    end
end


-- LISTENERS
--------------------------------------------------------------

Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(character, timer)
    if (timer == "StartedPlayingAnimation") then
        -- additional check to not have this looping
        if HasIdleStatus(character) then
            startPlayingIdleAnims(CleanPrefix(character))
        end
    end
end)


-- Initialize
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode) 
    onLevelGameplayStarted()
end)


