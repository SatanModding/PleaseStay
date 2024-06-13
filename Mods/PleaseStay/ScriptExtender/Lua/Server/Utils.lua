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





