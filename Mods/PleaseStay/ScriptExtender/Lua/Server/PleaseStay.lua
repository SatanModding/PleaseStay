
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
        Osi.AddPassive(party[i][1],"PLEASESTAY_STAY_STILL_PASSIVE")
        Osi.AddPassive(party[i][1],"PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
        Osi.AddSpell(party[i][1], "PLEASESTAY_CLEAR_ALL_PLEASESTAY_STATUSES")
    end
end)


-- Adds the "Stay in Camp" toggle to a partymember added during gameplay
Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
    Osi.AddPassive(character,"PLEASESTAY_STAY_STILL_PASSIVE")
    Osi.AddPassive(character,"PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
    Osi.AddSpell(character, "PLEASESTAY_CLEAR_ALL_PLEASESTAY_STATUSES")
end)



---------------------------------------------------------------------------------------------
--                              Stay Still Passive
---------------------------------------------------------------------------------------------


-- Stops the partymember from moving if "Stay Still" is activated and they are already in camp
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, _, _)
    if status == "PLEASESTAY_STAY_STILL_STATUS" then
		stopMoving(character)
	end
end)


-- Allows the partymember to move again if "Stay Still" is deactivated
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function (character, status, _, _)
	if status == "PLEASESTAY_STAY_STILL_STATUS" then
		startMoving(CleanPrefix(character))

        -- Remove Animation Toggle to stop animation overlap
        if HasIdleStatus(character) then
            Osi.TogglePassive(character, "PLEASESTAY_PLAY_ANIMATIONS_PASSIVE")
        end

	end
end)


-- Stops the partymember from moving if "Stay Still" is activated and they are teleported to camp
Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
    if Osi.HasActiveStatus(character, "PLEASESTAY_STAY_STILL_STATUS") == 1 then
        stopMoving(character)
    end
end)


-------------------------------------------------------------------------------------------------
--                                       Play Animation Passive
--------------------------------------------------------------------------------------------------




-- If "Play Animations" is activated, start playing animations
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, _, _)
    if status == "PLEASESTAY_PLAY_ANIMATIONS_STATUS" then
        -- Animations overlap if characters do their "in Camp" protocol
        -- Add "Stay Still" status to circumvent. Might be confusing to users. Add explanation
        if not HasStayStillStatus(character) then
            Osi.TogglePassive(character, "PLEASESTAY_STAY_STILL_PASSIVE")
        end
        startPlayingIdleAnims(CleanPrefix(character))
	end
end)


---------------------------------------------------------------------------------------------------
--                                          Spell Listener
---------------------------------------------------------------------------------------------------

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_, spell, _, _, _)  
    if spell == "PLEASESTAY_CLEAR_ALL_PLEASESTAY_STATUSES" then
        untoggleStayStillEveryone()
        untoggleAnimationEveryone()
    end
end)
    

---------------------------------------------------------------------------------------------
--  Remove and reapply Stay Still Passive on convo start - fixes obscure bug about audio getting muted
---------------------------------------------------------------------------------------------


Ext.Osiris.RegisterListener("WentOnStage", 2, "after", function(object, isOnStageNow) 

    for _, uuid in pairs(GetEveryoneThatIsRelevant())do

        if HasIdleStatus(uuid) then
            Osi.ObjectTimerLaunch(uuid, "PleaseStay_UntoggledAnimationStatusForDialogue", 1500)
        end

        if HasStayStillStatus(uuid) then
            Osi.TogglePassive(uuid, "PLEASESTAY_STAY_STILL_PASSIVE")
            Osi.ObjectTimerLaunch(uuid, "PleaseStay_UntoggledStayStillStatusForDialogue", 1000)
        end

        
    end
end)

---------------------------------------------------------------------------------------------------
--                                          Timer
---------------------------------------------------------------------------------------------------


-- Reapply the "Stay Still" Passiv after the dialog has started
Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(uuid, timer)
    if (timer == "PleaseStay_UntoggledStayStillStatusForDialogue") then
        Osi.TogglePassive(uuid, "PLEASESTAY_STAY_STILL_PASSIVE") 
    end
end)

-- Reapply the "Stay Still" Passiv after the dialog has started
Ext.Osiris.RegisterListener("ObjectTimerFinished", 2, "after", function(uuid, timer)
    if (timer == "PleaseStay_UntoggledAnimationStatusForDialogue") then
        Osi.TogglePassive(uuid, "PLEASESTAY_PLAY_ANIMATIONS_PASSIVE") 
    end
end)

