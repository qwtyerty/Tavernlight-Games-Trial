--[[
	Explanation:	The implemented function would check for a specific member and 
					iterate through all party members and checking if the member's name
					matches then removing them. The name has been adjusted to 
					removeMemberFromPlayerParty as the function searches for and
					removes the member from the party. 

					The parameters have been updated to take in the player, and memberId
					passing the player makes it easier to get the party, and the memberId
					seemed like the best way to do comparsion, however if there is a method
					to get the name of the member, which is likely, it would be equivalent.
					The method now verfies that the player is party leader as it would not
					make sense for any party member to be able to kick other members, as this
					would likely lead to griefing.

					The for loop has been upodated to be more clear, and a return statement was
					add to save time in the case the member is early in the table.
]]


--[[
	Brief		Removes a member from a player's party
	Details		Verifies that the player is party leader then iterates over all
				party members until the member is found then removed or all 
				members have been checked
	Param		player:		player whose party the member will be removed from
	Param		memberId:	ID of the member to be removed
	retVal		None
]]

function removeMemberFromPlayerParty(player, memberId)
	local party = player:getParty()

	-- Check if the player is party leader
	if party:getLeader() ~= player then
		return
	end

	-- Check all party members 
	for _, member in pairs(party:getMembers()) do

		-- Check for a match
		if member:getId() == memberId then

			-- Remove member and end search
			party:removeMember(member)
			return
		end
	end
end