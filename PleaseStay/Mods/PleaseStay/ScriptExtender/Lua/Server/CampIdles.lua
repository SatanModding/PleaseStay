
------------------------------------------------------------------------------------------------------------------------------
--
--
--                                         For handling playing camp idles
--
--
---------------------------------------------------------------------------------------------------------------------------




-- VARIABLES
--------------------------------------------------------------

-- whether playing an animation is still allowed
-- key: uuid
-- value: bool

function getAnimationsAllowed()
    return PersistentVars['animationsAllowed']
end


-- GETTERS AND SETTERS
--------------------------------------------------------------

-- Function to set whether animations are allowed for a specific UUID
--@param uuid string 
--@param bool bool
function setAnimationsAllowed(uuid, bool)
    PersistentVars['animationsAllowed'][uuid] = bool
end

-- Function to get whether animations are allowed for a specific UUID
--@param uuid string 
--@param      bool
function getAnimationsAllowed(uuid)
    return PersistentVars['animationsAllowed'][uuid]
end

--------------------------------------------------------------
--
--                           METHODS
--
--------------------------------------------------------------


-- Toggling
--------------------------------------------------------------

-- untoggles the Stay Still passive
--@param character string
function untoggleAnimation(character)
    Osi.TogglePassive(character, "PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
    setAnimationsAllowed(character, false) 
end


-- untoggles the Stay Still passive for every entity that has it toggled on
function untoggleAnimationEveryone()
    for uuid, bool in pairs(PersistentVars['animationsAllowed'])do
        if bool then
            untoggleAnimation(uuid)
        end
    end
end



-- Playing Animations
--------------------------------------------------------------

-- stops playing idle animations for a character
--@param character string
function stopPlayingIdleAnims(character)
    PersistentVars['animationsAllowed'][character] = false
end



-- plays idle animations for a character every few seconds
--@param character string
function startPlayingIdleAnims(character)
    if ANIMATIONS[character] and PersistentVars['animationsAllowed'][character] and PersistentVars['stayStillApplied'][character] then
            if not (character == Osi.GetHostCharacter()) then
                local i = math.random(#ANIMATIONS[character])
                local animation =  ANIMATIONS[character][i]
                pcall(Osi.PlayAnimation, character,  animation)
            end
        Osi.ObjectTimerLaunch(character, "StartedPlayinAnimation",40000)
    end
end



-- Initializing
-----------------------------------------------------------------


-- Initializes PersVars
local function onSessionLoaded()
    if not PersistentVars['animationsAllowed'] then
        PersistentVars['animationsAllowed'] = {}
    end

end


local function onLevelGameplayStarted()
    -- resume idle animations 

    local party = Osi.DB_PartyMembers:Get(nil)
    for i = #party, 1, -1 do
        startPlayingIdleAnims(CleanPrefix(party[i][1]))
    end
end



-- LISTENERS
--------------------------------------------------------------

Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(character, timer)
    if (timer == "StartedPlayinAnimation") then
        startPlayingIdleAnims(CleanPrefix(character))
    end
end)




-- Initializes PersVars
Ext.Events.SessionLoaded:Subscribe(onSessionLoaded)


-- Initialize
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode) 
    onLevelGameplayStarted()
end)


