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


--------------------------------------------------------------
--
--                           METHODS
--
--------------------------------------------------------------

-- Helpers
--------------------------------------------------------------

-- Returns whether a character has the "Stay Still" status active
--@param  uuid string
--@return bool
function HasStayStillStatus(uuid)
    if Osi.HasActiveStatus(uuid, "PLEASESTAY_STAY_STILL_STATUS") == 1 then
        return true 
    else
        return false
    end
end


local function isInCamp(character)
    if Ext.Entity.Get(character).CampPresence ~= nil then
        return true
    else
        return false
    end
end


-- Toggling
--------------------------------------------------------------

-- untoggles the Stay Still passive for every entity that has it toggled on
function untoggleStayStillEveryone()
    for _, uuid in pairs(GetEveryoneThatIsRelevant())do
        if HasStayStillStatus(uuid) then
            Osi.TogglePassive(character, "PLEASESTAY_STAY_STILL_PASSIVE") 
        end
    end
end


-- Setting and Clearing flags.
--------------------------------------------------------------

---@param character GUIDSTRING     - the character who will stop moving in camp
function stopMoving(character)
    if Osi.GetFlag(FLAG_IN_CAMP, character) == 1 then
        Osi.ClearFlag(FLAG_IN_CAMP, character)  
    end
end


------------------------------------------------------------------------------------------------------


---@param character GUIDSTRING     - the character who will start moving again in camp
function startMoving(character)

    if Osi.GetFlag(FLAG_IN_CAMP, character) == 0 then

        if isInCamp(character) then
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
