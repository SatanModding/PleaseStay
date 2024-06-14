------------------------------------------------------------------------------------------------------------------------------
--
--
--          Authors Note: If anyone is looking at this mod for trying to learn from it please note the following:
--
--          During the development of this mod we did not yet have access to the Ext.Timer functions from SE. 
--          For this reason Osi Timers have been used. These are not recommened but have been kept here.
--          Please use Ext Timers if necessary
--
---------------------------------------------------------------------------------------------------------------------------

Ext.Require("Server/BODIES.lua")
Ext.Require("Server/PleaseStay.lua")

Ext.Require("Server/DATA_CAMPIDLES.lua")

Ext.Require("Server/Utils.lua")


Ext.Require("Server/StayStill.lua")
Ext.Require("Server/CampIdles.lua")



PersistentVars = {}



-- ANIMATIONS
--------------------------------------------------------------


-- List of all camp idles for all companions with their IDs

ANIMATIONS_TESTING = {
    --Generic
    ["any"] = {
        "CUST_Bored_02_7892cb3b-2935-4aa3-b65c-64d9664cbe75",
        "CUST_Dejected_01_Loop_487b6cb3-1ca3-4041-acba-bcac93cfcbe5",
        "CUST_LookingAround_63bcacef-5631-4ab3-9400-81b23cb18ca7",
        "CUST_Meditating_01_45b1a54b-b127-46d2-bfe6-daa8963398ea",
        "CUST_Pondering_01_Loop_a47454a1-05a2-4153-bdfe-7a0500fa62d0",
        "CUST_Praying_01_Loop_b45ab827-aebd-49ed-9ac7-07a1489a5490",
        "CUST_Reading_Book_01_c3af4377-7383-4aeb-a067-d8c36e82f716",
        "CUST_Reading_Book_01_Loop_d8db9dc7-c6dd-4b6f-8af0-620c7473d8f8",
        "CUST_Thinking_01_97588786-d9bf-4d18-879b-1bd3dcaa62ba",
        "CUST_WarmingByFire_01_Loop_e2d0b8f4-00ae-49a4-a878-a9841fd78a96"
    }, 

    -- Gale
    ["ad9af97d-75da-406a-ae13-7071c563f604"] = {
        "CUST_Thinking_01_97588786-d9bf-4d18-879b-1bd3dcaa62ba",
        "CUST_EPI_Gale_Chatting_01_Loop_c49d9988-44f0-47ec-8afb-7c08857f7852",
        "CUST_EPI_Gale_Drinking_01_Loop_ac8eb7ae-4e86-4f82-8586-ea152572f8c6",
        "CUST_EPI_Gale_Eating_01_ac88a100-cd5e-48bc-9a3e-eb3da16b2f9b",
        "CUST_EPI_GaleAvernus_Reading_Book_01_02aa2345-32c0-4e51-a384-ba1ea4cf71ec",
        "CUST_EPI_Gale_Chatting_01_Loop_c49d9988-44f0-47ec-8afb-7c08857f7852",
        "CUST_EPI_GaleGod_Drinking_01_28c60b89-0685-4707-ab82-18fc12ca70d2",
        "CUST_EPI_GaleGod_IdleRandom_01_1c29e931-f968-42dd-b18d-f4452ffadb09",
        "CUST_EPI_GaleSpectral_Waving_01_fad4b08f-470b-4816-9dda-9b03399782c0"
    },
    -- Minsc
    ["0de603c5-42e2-4811-9dad-f652de080eba"] = {
        "CUST_EPI_Minsc_ShaveHead_01_dea9b80f-6e67-461d-a292-91075be50438",
        "CUST_Minsc_PlayingDrum_01_e7f761fc-8441-4424-9bf5-b43daca47f18",
        "CUST_EPI_Minsc_StuffFoods_01_6a821ed2-15d4-4814-b607-c639a962095a",
        "CUST_EPI_Minsc_FlexingMuscle_01_6d1732cd-761d-4cab-973c-17e03ba4ee2f"
    },
    -- Wyll
    ["c774d764-4a17-48dc-b470-32ace9ce447d"] = {
        "CUST_EPI_AvernusWyll_Dance_01_Loop_9dab7359-b7c6-468f-917d-d2fe76be0829",
        "CUST_EPI_AvernusWyll_SittingOnFloorDrink_01_Loop_40d59dd0-1364-46c2-ba02-e0b4f52bad98",
        "CUST_EPI_DukeWyll_EnjoyingTheMusic_01_Loop_63221d04-2ae3-4d7e-a626-a86c0c717222",
        "CUST_EPI_DukeWyll_Reading_01_Loop_e7047375-2edf-4c19-a408-e1f507020e78",
        "CUST_EPI_Wyll_Clap_01_Loop_923fd6d1-7ff6-4cdd-ae46-7ae0d1ee043b",
        "CUST_EPI_Wyll_Drinking_01_Loop_3dd86f4a-a63a-4e90-92d5-de5a14da6474"
    },
    -- Shart
    ["3ed74f06-3c60-42dc-83f6-f034cb47c679"] = {
        "CUST_EPI_Shadowheart_Dance_01_Loop_2a82690c-f334-4f0d-964f-0161f9efd9e6",
        "CUST_EPI_Shadowheart_Stargazing_01_Loop_3d2ad8b1-f894-4ecb-ac07-de2c482e537a",
        "CUST_EPI_Shadowheart_TestingWaters_01_Loop_eacaabfe-307d-492b-8826-6581bb841bff",
        "CUST_EPI_Shadowheart_LookingAtFlower_01_Loop_a481a91e-d3f1-4247-bbbd-6c33d39eff15",
        "CUST_EPI_Shadowheart_Eating_01_b8eeb9da-8c8c-4727-8af9-46852860f988",
        "CUST_EPI_Shadowheart_WoundFlaring_01_1e154f3b-825a-4a19-8200-e777bb87388f"
    },
    -- Jaheira
    ["91b6b200-7d00-4d62-8dc9-99e8339dfa1a"] = {
        "CUST_Jaheira_Whittling_01_Loop_96344f40-2814-4267-99c4-2c30b57fd970",
        "CUST_EPI_Jaheira_FlutePlaying_01_b6673e38-04d2-47df-ae4a-a70ad2861d22",
        "CUST_EPI_Jaheira_ListeningtoMusic_01_315bb6e9-01ea-4fff-adb8-8a5b7ed9527b",
        "CUST_EPI_Jaheira_WarmHands_01_34b15837-2e6b-4090-a2ae-a0ed62efc475",
        "CUST_EPI_Jaheira_WineDrinking_01_283e288f-d922-49c5-b136-bfb383b4c95b",
        "CUST_EPI_Jaheira_TakeFood_01_f5d47560-8534-4eba-9e9e-f42e92ffd529"
    },
    -- Halsin
    ["7628bc0e-52b8-42a7-856a-13a6fd413323"] = {
        "CUST_EPI_Halsin_WarmHandsBonfire_01_2e97dfe0-2224-4469-9c62-754690688a9a",
        "CUST_EPI_Halsin_Dance_01_Loop_e0bbddb0-4e03-4f74-8fd4-dc172026de66",
        "CUST_EPI_Halsin_UncomfortableClothes_01_89e3c1ba-85e8-4a1e-ae95-9b8a1ffa140c",
    },
    -- Astarion
    ["c7c13742-bacd-460a-8f65-f864fe41f255"] = {
        "CUST_EPI_CazAstarion_Pacing_01_3c5d3520-c03c-409c-8163-0a813c7476cb",
        "CUST_EPI_CazAstarion_SharpensDagger_01_8642de6d-1377-4ba8-a32d-e90c236b5ef5",
        "CUST_EPI_CazAstarion_DaggerThrow_01_13475c87-29df-4e84-87e7-e5c115e81b92",
        --"CUST_EPI_LordAstarion_AdmireSelf_01_63a53475-7e81-48a5-af90-5d6f2f4c5149", Astariona admires himself in the mirror. Not lore accurate
        "CUST_EPI_Astarion_KnifeTricks_01_3946137b-d703-492b-a916-09912d3bf867",
        "CUST_EPI_Astarion_DustSelf_01_9b8f3897-bb74-4a83-ac5e-d95bd0b0e9f4",
        "CUST_EPI_Astarion_CombHair_01_b9a9cc36-4159-441e-bc9c-a85b3ae09873",
        "CUST_EPI_SpawnAstarion_SittingDown_01_Loop_7dced1aa-b12d-49ba-9963-be6c8b8e8e1b"
    },
    --Minthara
    ["25721313-0c15-4935-8176-9f134385451b"] = {
        "CUST_Minthara_AdjustingOutfit_01_19bbe55d-e338-4fe3-8900-e17977949ff7",
        "CUST_Minthara_BotheredbySun_01_4f4b0dba-d426-4a05-a7af-0ef614dfd091",
        -- "CUST_EPI_Minthara_EnjoyingParty_01_f2e2145e-39b6-4038-aa77-9157f69a9204", looks weird without table
        "CUST_EPI_Minthara_Eating_01_ffcf5fd1-862b-4765-8645-3cbc0f96432c",
        "CUST_EPI_Minthara_Drinking_01_09f84725-67ec-4680-b415-b0c2b176ac55",
        "CUST_EPI_Minthara_Bored_01_8fdbac5c-f4a9-4d25-b7ea-bbbae6147753",
        "CUST_EPI_Minthara_LookAround_01_e957120e-e00d-4a47-8c7b-f58e12f83f7f",
        -- "CUST_EPI_Minthara_Relaxed_01_b49ea08e-1fa9-48f1-9799-d3c0f66afb0c" looks boring
    },
    --Laezel
    ["58a69333-40bf-8358-1d17-fff240d7fb12"] = {
        "CUST_EPI_Laezel_ListeningToMusic_01_5c426fd3-76ec-4165-ab9b-f2582c046743",
        "CUST_EPI_Laezel_DrinkingWine_01_bc14695d-b614-475c-9dcb-a54684e825b6",
        "CUST_EPI_Laezel_LookingUp_01_b571f848-91d4-4777-b551-0e60e1973f61",
        "CUST_EPI_Laezel_LookingUp_02_4cb2583a-3213-41dd-ba2d-884496da4146",
        "CUST_EPI_Laezel_LookingAround_01_564143d2-e7dc-4eae-9eca-e8ddf1ae71b8"
    },
    -- Karlach
    ["2c76687d-93a2-477b-8b18-8a14b549304c"] = {
        "CUST_EPI_Karlach_Dance_01_Loop_0939135a-a08c-4025-9bcd-1d53b2758474",
        "CUST_EPI_Karlach_Jamming_01_Loop_3c70c66b-1d9a-4d4d-a2bb-9f1cd31d1727",
        "CUST_EPI_Karlach_StargazingStand_01_Loop_f80235d8-5c96-4dfc-a9a6-cc928606b156",
        "CUST_EPI_Karlach_StargazingSit_01_Loop_43384cb6-9fab-4c91-ac9b-5ecde0e8d61c",
        "CUST_EPI_Karlach_PickFlower_01_af2606cb-dc75-4beb-a266-735b05a28e54",
        "CUST_EPI_Karlach_PartyTrick_01_5a13f6b9-357b-4290-a14f-41b907146e68",
        "CUST_EPI_Karlach_HappyBurst_01_c485ac2d-7947-4a23-a2a3-1efd32d29e6d",
        "CUST_EPI_Karlach_TalkPlush_01_Loop_bffca561-6d7c-4379-a60f-5ff3b251fc3e",
        "CUST_EPI_Karlach_HugPlush_01_61a8916f-e214-4a5a-a560-f8b3b8ccc7a3",
        "CUST_EPI_Karlach_PushUp_01_6b4ca414-cb8c-4d0c-9258-da8631f05537"
    }
}



-- Praying doesn't seem to work for Astarion

local function generic()

    delay = 40000 
    
    _P("Starting Generic animations")
    for key, values in pairs(ANIMATIONS_TESTING) do 
        -- all anims with a 40 sec delay
        if key == "any" then
            for _, anim in pairs(values) do
                Ext.Timer.WaitFor(delay, function() 
                    print("Playing ", anim)
                    Osi.PlayAnimation(GetHostCharacter(), anim)
                end
                )
                delay = delay + 40000 
            end
        end
    end 
end


Ext.RegisterConsoleCommand("generic", generic);



-- Quick anim change to check whether they work
local function companions_fast()

    delay = 5000
    
    _P("Starting Companions fast animations")
    for key, values in pairs(ANIMATIONS_TESTING) do 
        -- all anims with a 40 sec delay
        if not (key == "any") then
            for _, anim in pairs(values) do
                Ext.Timer.WaitFor(delay, function() 
                    print("Playing ", anim)
                    Osi.PlayAnimation(GetHostCharacter(), anim)
                end
                )
                delay = delay + 5000
            end
        end
    end 
end


Ext.RegisterConsoleCommand("companions_fast", companions_fast);


-- Full animation length
local function companions_full()

    delay = 40000 
    
    _P("Starting Companions full animations")
    for key, values in pairs(ANIMATIONS_TESTING) do 
        -- all anims with a 40 sec delay
        if not (key == "any") then
            for _, anim in pairs(values) do
                Ext.Timer.WaitFor(delay, function() 
                    print("Playing ", anim)
                    Osi.PlayAnimation(GetHostCharacter(), anim)
                end
                )
                delay = delay + 40000 
            end
        end
    end 
end


Ext.RegisterConsoleCommand("companions_full", companions_full);

