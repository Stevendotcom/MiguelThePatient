
function IsTouching(this, other)
    -- iterate contacts
    local contacts = this:getContacts()
    for i, contact in ipairs(contacts) do
        -- look for a specific body
        local f1, f2 = contact:getFixtures()
        if f1:getBody() == other or f2:getBody() == other then
            return true
        end
    end
    return false
end

