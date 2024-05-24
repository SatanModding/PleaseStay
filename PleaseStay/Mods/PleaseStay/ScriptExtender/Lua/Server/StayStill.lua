------------------------------------------------------------------------------------------------------------------------------
--
--
--                                         For handling The "Stay Still" Passive and Boost
--
--
---------------------------------------------------------------------------------------------------------------------------

-- CONSTANTS
--------------------------------------------------------------

FLAG_IN_CAMP = "161b7223-039d-4ebe-986f-1dcd9a66733f"


-- VARIABLES
--------------------------------------------------------------

-- whether the entity has Stay Still applied
-- key: uuid
-- value: bool

function getStayStillApplied()
    return PersistentVars['stayStillApplied']
end


function getActuallyInCamp()
    return PersistentVars['actuallyInCamp']
end



-- GETTERS AND SETTERS
--------------------------------------------------------------

-- add an entity to the stayStillApplied set
--@param uuid string
function setStayStillApplied(uuid)
    PersistentVars['stayStillApplied'][uuid] = true
end

-- remove an entity to the stayStillApplied set
--@param uuid string
function removeStayStillApplied(uuid)
    PersistentVars['stayStillApplied'][uuid] = false
end


-- add an entity to the actuallyinCamp set
--@param uuid string
function setActuallyInCamp(uuid)
    PersistentVars['actuallyInCamp'][uuid] = true
end

-- remove an entity to the stayStillApplied set
--@param uuid string
function removeActuallyInCamp(uuid)
    PersistentVars['actuallyInCamp'][uuid] = false
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
function untoggleStayStill(character)
    Osi.TogglePassive(character, "STAY_STILL_PASSIVE") 
    removeStayStillApplied(character)
end


-- untoggles the Stay Still passive for every entity that has it toggled on
function untoggleStayStillEveryone()
    for uuid, bool in pairs(PersistentVars['stayStillApplied'])do
        if bool then
            untoggleStayStill(uuid)
        end
    end
end


-- Setting and Clearing passives, flags etc.
--------------------------------------------------------------

---@param character GUIDSTRING     - the character receiving the passive
---@return passive - string         - the passive being added to the character
function addPassive(character, passive)
    if Osi.HasPassive(character, passive) == 0 then
        Osi.AddPassive(character, passive)
    end
end


---@param character GUIDSTRING     - the character who will stop moving in camp
function stopMoving(character)
    if Osi.GetFlag(FLAG_IN_CAMP, character) == 1 then
        Osi.ClearFlag(FLAG_IN_CAMP, character)  
    end
end


-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

------------------------------------------------------------------------------------------------------



---@param character GUIDSTRING     - the character who will start moving again in camp
function startMoving(character)


    if Osi.GetFlag(FLAG_IN_CAMP, character) == 0 then

        if PersistentVars['actuallyInCamp'][character] then
            Osi.SetFlag(FLAG_IN_CAMP, character)
        else
            local id
            -- Only set flag once in camp, else they teleport
            id = Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character) 
                Osi.SetFlag(FLAG_IN_CAMP, character)
                Ext.Osiris.UnregisterListener(id)
            end)
        end
    end
end



-------------------------------------------------------------------------------------------------------

-- Initializes PersVars
local function onSessionLoaded()
    if not PersistentVars['stayStillApplied'] then
        PersistentVars['stayStillApplied'] = {}
    end

    if not PersistentVars['actuallyInCamp'] then
        PersistentVars['actuallyInCamp'] = {}
    end
end


-- Check whether they ar ein camp
local function onLevelGameplayStarted()

    local party = Osi.DB_PartyMembers:Get(nil)
    for i = #party, 1, -1 do
        if Ext.Entity.Get(party[i][1]).CampPresence ~= nil then
            character = party[i][1]
            setActuallyInCamp(CleanPrefix(character))
        end
    end
end



-- LISTENERS
--------------------------------------------------------------



-- check whether characters are in camp - this is mostly only needed once
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode) 
    onLevelGameplayStarted()
end)


-- Initializes PersVars
Ext.Events.SessionLoaded:Subscribe(onSessionLoaded)

