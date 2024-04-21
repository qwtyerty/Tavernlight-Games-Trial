--[[
	Explanation:	The original method only printed the first guild name received from the database
					rather than printing all of the guilds names that have been fetched from the database.
]]

--[[
	Brief		Prints all guild names with max_members less than memberCount 
	Details		Queries the database for rows where the number of max_members is less than memberCount
				then iterates through the rows from the query and prints the guild's name until there
				are no rows left from the query.
	Param		memberCount:	Number of max members required to be considered a small guild
	retVal		None
]]
function printSmallGuildNames(memberCount)
	-- this method is supposed to print names of all guilds that have less than memberCount max members

	-- Query for selecting a name of a guild with fewer that memberCount max members
	local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"

	-- Query the database 
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

	-- Fetch each result from the query and print the selected name
	while resultId then
		local guildName = result.getString(resultId, "name")
		print(guildName)
		result.next(resultId)
	end
end