--[[
	Explanation:
		Assumning that it is possible that the storage value in index 1000 can vary
		depending on a number of unknown factors so the safest way to check if the 
		storage has been released is to check that the value is different rather than 
		checking if it is equal to 1. Additionally the return after the if block is	
		unnecessary as both control branches reach the return statement so true can
		just be assumed rather than returned. Although the 1000 in the addEvent call
		seems odd, addEvent expects parameters in the order of function to call, delay,
		and then parameters for the called function. Rather than removing delays constants
		are added to make the code easier to read.
]]

STORAGE_INDEX = 1000
RELEASE_DELAY = 1000

--[[
	Brief		Releases a player's storage
	Details		Releases a player's storage buy setting the
				STORAGE_INDEX storage to -1 in order to remove
				the item.
	Param		player:		Player's storage to release
	retval		None
]]
local function releaseStorage(player)
	player:setStorageValue(STORAGE_INDEX, -1)
end


--[[
	Brief		Execute Logout Tasks
	Details		When a logout occurs, adds an event to release the players storage
				after a delay of RELEASE_DELAY, if the player's storage has not already
				released
	Param		player:		PLayer who is logging out
	retval		None
]]
function onLogout(player)
	if player:getStorageValue(STORAGE_INDEX) ~= -1 then
		addEvent(releaseStorage, RELEASE_DELAY, player)
	end
end
