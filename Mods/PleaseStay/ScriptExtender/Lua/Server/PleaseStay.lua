
------------------------------------------------------------------------------------------------------------------------------
--
--
--                                         Main Method
--
--                    
---------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------
--
--                              LISTENERS
--
-----------------------------------------------------------------



----------------------------------------------------------------
--                     Spell and Passive addition    
----------------------------------------------------------------

-- Adds the "Stay in Camp" toggle to each partymember
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)

    local party = Osi.DB_PartyMembers:Get(nil)
    for i = #party, 1, -1 do
        addPassive(party[i][1],"STAY_STILL_PASSIVE")
        addPassive(party[i][1],"PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
        TryAddSpell(party[i][1], "PLEASESTAY_START_MOVING_ALL")
    end
end)


-- Adds the "Stay in Camp" toggle to a partymember added during gameplay
Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
    addPassive(character,"STAY_STILL_PASSIVE")
    addPassive(character,"PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
    TryAddSpell(character, "PLEASESTAY_START_MOVING_ALL")
end)



---------------------------------------------------------------------------------------------
--                              Stay Still Passive
---------------------------------------------------------------------------------------------


-- Stops the partymember from moving if "Stay Still" is activated and they are already in camp
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, _, _)
    if status == "STAY_STILL_STATUS" then
        setStayStillApplied(CleanPrefix(character))
		stopMoving(character)
        startPlayingIdleAnims(CleanPrefix(character))
	end
end)


-- Allows the partymember to move again if "Stay Still" is deactivated
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function (character, status, _, _)
	if status == "STAY_STILL_STATUS" then
		startMoving(CleanPrefix(character))
        removeStayStillApplied(CleanPrefix(character))
        stopPlayingIdleAnims(character)
	end
end)



-- Stops the partymember from moving if "Stay Still" is activated and they are teleported to camp
Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
        setActuallyInCamp(CleanPrefix(character))
    if Osi.HasActiveStatus(character, "STAY_STILL_STATUS") == 1 then
        stopMoving(character)
        startPlayingIdleAnims(CleanPrefix(character))
    end
end)


Ext.Osiris.RegisterListener("TeleportedFromCamp", 1, "after", function(character) 
    removeActuallyInCamp(CleanPrefix(character))
end)


-------------------------------------------------------------------------------------------------
--                                       Play Animation Passive
--------------------------------------------------------------------------------------------------


-- If "Stay Still" is activated and the party members are teleported to camp they start playing idle animations manually
-- This will stop when the status is removed
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, _, _)
    if status == "PLEASESTAY_PLAY_ANIMATIONS_STATUS" then
        setAnimationsAllowed(CleanPrefix(character), true)
        startPlayingIdleAnims(CleanPrefix(character))
	end
end)



-- Party members stop playing idle animations if the status is removed
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function (character, status, _, _)
	if status == "PLEASESTAY_PLAY_ANIMATIONS_STATUS" then
        stopPlayingIdleAnims(CleanPrefix(character))
	end
end)



-- If "Stay Still" is activated and the party members are teleported to camp they start playing idle animations manually
Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
    if Osi.HasActiveStatus(character, "PLEASESTAY_PLAY_ANIMATIONS_STATUS") == 1 then
        setAnimationsAllowed(CleanPrefix(character), true)
        startPlayingIdleAnims(CleanPrefix(character))
    end
end)


-- Stops idle animations when character is not in camp anymore
Ext.Osiris.RegisterListener("TeleportedFromCamp", 1, "after", function(character)  
     stopPlayingIdleAnims(CleanPrefix(character))
end)



---------------------------------------------------------------------------------------------------
--                                          Spell Listener
---------------------------------------------------------------------------------------------------

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_, spell, _, _, _)  
    if spell == "PLEASESTAY_START_MOVING_ALL" then
        untoggleStayStillEveryone()
        untoggleAnimationEveryone()
    end
end)
    


---------------------------------------------------------------------------------------------
--                     Remove and reapply Stay Still Passive on convo start
---------------------------------------------------------------------------------------------


Ext.Osiris.RegisterListener("WentOnStage", 2, "after", function(object, isOnStageNow) 

    for uuid, bool in pairs(getStayStillApplied()) do
        if bool then
            untoggleStayStill(uuid)
            Osi.ObjectTimerLaunch(uuid, "PleaseStay_UntoggledStatusForDialogue", 1000)
        end
    end
end)



---------------------------------------------------------------------------------------------------
--                                          Timer
---------------------------------------------------------------------------------------------------


-- Reapply the "Stay Still" Passiv after the dialog has started
Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(uuid, timer)
    if (timer == "PleaseStay_UntoggledStatusForDialogue") then
        Osi.TogglePassive(uuid, "STAY_STILL_PASSIVE") 
    end
end)



