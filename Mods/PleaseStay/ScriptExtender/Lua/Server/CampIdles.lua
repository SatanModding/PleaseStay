
------------------------------------------------------------------------------------------------------------------------------
--
--
--                                         For handling playing camp idles
--
--
---------------------------------------------------------------------------------------------------------------------------




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



-- Bodytype/race specific animations
--------------------------------------------------------------


-- returns bodytype and bodyshape of entity
--@param character string - uuid
--@param bt int           - bodytype  [0,1]
--@param bs int           - bodyshape [0,1]
local function getBody(character)

    -- Get the properties for the character
	local E = GetPropertyOrDefault(Ext.Entity.Get(character),"CharacterCreationStats", nil)
	local bt =  Ext.Entity.Get(character).BodyType.BodyType
	local bs = 0

	if E then
		bs = E.BodyShape
	end

    return bt, bs

end



-- returns the cc bodytype based on entity bodytype/bodyshape
--@param bodytype  int   - 0 or 1
--@param bodyshape int   - 0 or 1
--@param cc_bodytype int - [1,2,3,4]
local function getCCBodyType(bodytype, bodyshape)
    for _, entry in pairs(CC_BODYTYPE) do
        if (entry.type == bodytype) and (entry.shape == bodyshape) then
            return entry.cc
        end 
    end
end

-- returns race of character - if modded, return human
--@param character string - uuid
--@return race     string - uuid
local function getRace(character)

    local raceTags = Ext.Entity.Get(character):GetAllComponents().ServerRaceTag.Tags

    local race
    for _, tag in pairs(raceTags) do
        if RACETAGS[tag] then
            race = GetKey(RACES, RACETAGS[tag])
            break
        end
    end

    -- fallback for modded races - mark them as humanoid
    if not RACES[race] then
        race = "0eb594cb-8820-4be6-a58d-8be7a1a98fba"
    end

    return race

end


-- PRAYING:

-- Not: bt2, bt3, bt4 , unless Gnome
-- Not DGB, Dwarf, Orc 
-- Special case: Orc bt2
local function prayingAllowed(bt, race)

    -- Gnome works for any bodytypes    
    if race == "f1b3f884-4029-4f0f-b158-1f9fe0ae5a0d" then
        return true
    
    -- Orc bt2 works   
    elseif (race == "5c39a726-71c8-4748-ba8d-f768b3c11a91") and (bt == 2) then
        return true

    elseif bt == 1 then
        -- DGB, Dwarf, Orc have to be filtered out
        if (race == "9c61a74a-20df-4119-89c5-d996956b6c66") or (race == "0ab2874d-cfdc-405e-8a97-d37bfbb23c52") or (race == "5c39a726-71c8-4748-ba8d-f768b3c11a91") then 
            return false
        else
            return true
        end
    end
end



-- THINKING 
-- Everyone except halfling & gnome bt1 (femme)
local function thinkingAllowed(bt, race)

    if (bt == 1) and (( race == "78cd3bcc-1c43-4a2a-aa80-c34322c16a04" ) or (race == "f1b3f884-4029-4f0f-b158-1f9fe0ae5a0d")) then
        return false
    else
        return true
    end 

end





-- Animation Filtering
--------------------------------------------------------------


-- Returns the allowed animations for a character (based on whether they are an Origin, bodytype [and maybe race - waiting for test results])
local function getAllowedAnimations(character)
    -- General works for everyone. Origins get their special ones + general
    -- Everyone else gets General

    local allowedAnimations
    local generics = ANIMATIONS["any"]

    -- Origin animations
    for uuid, animationList in pairs(ANIMATIONS) do
        if uuid == character then
            allowedAnimations = Concat(generics, animationList)
        end
    end

    -- Tavs etc
    if allowedAnimations == nil then
        allowedAnimations = generics
    end


    local bt, bs = getBody(character)
    local cc_bodytype = getCCBodyType(bt, bs)
    local race = getRace(character)

    -- some animations are bodytype & race locked
    if prayingAllowed(cc_bodytype, race) then
        allowedAnimations = Concat(allowedAnimations, ANIMATIONS["pray"])
    end

    if thinkingAllowed(cc_bodytype, race) then
        allowedAnimations = Concat(allowedAnimations, ANIMATIONS["think"])
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
        _P("Playing animation ",  character, " ", animation)
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


