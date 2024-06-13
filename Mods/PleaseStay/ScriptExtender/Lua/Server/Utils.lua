------------------------------------------------------------------------------------------------------------------------------
--
--
--                                           Utility functions 
--
--
---------------------------------------------------------------------------------------------------------------------------



-- Function to perform a deep copy of a table
function DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end



-- Function to clean the prefix and return only the ID
function CleanPrefix(fullString)
    -- Use pattern matching to extract the ID part
    local id = fullString:match(".*_(.*)")
    return id
end



-- Function to check if not all values are false
function NotAllFalse(data)
    for _, value in pairs(data) do
        if value then
            return true
        end
    end
    return false
end

-- Concatenate 2 tables into one
-- @param t1 		
-- @parma t2
-- @return 			- concatenated lists
function Concat(t1, t2)
    local result = {}
    for i = 1, #t1 do
        result[#result + 1] = t1[i]
    end
    for i = 1, #t2 do
        result[#result + 1] = t2[i]
    end
    return result
end



-- Credit to FallenStar  https://github.com/FallenStar08/SharedCode
-- Slightly modified version

--Returns all aummons, avatars and Origins
function GetEveryoneThatIsRelevant()
    local goodies = {}
    local avatarsDB = Osi.DB_Avatars:Get(nil)
    local originsDB = Osi.DB_Origins:Get(nil)
    local summonsDB = Osi.DB_PlayerSummons:Get(nil)

    for _, avatar in pairs(avatarsDB) do
        goodies[#goodies + 1] = avatar[1]
    end

    for _, origin in pairs(originsDB) do
        goodies[#goodies + 1] = origin[1]
    end

    for _, summon in pairs(summonsDB) do
        goodies[#goodies + 1] = summon[1]
    end

    return goodies
end




