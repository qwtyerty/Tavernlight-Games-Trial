--[[
	@brief		Implements a dashing spell
	@details	Implements a dashing spell that checks up to @ref TILE_LIMIT tiles ahead of 
				the player, in the direction they are facing, and checking if the tile is
				valid and passable before attempting to move the player tile-by-tile
]]

-- Max Tile can be dashed
local TILE_LIMIT = 8

-- All possible directions and their associated x,y transforms
local DIRECTION_TRANSFORMS = {
	{0, -1}, -- UP
	{1, 0}, -- RIGHT
	{0, 1},	-- DOWN
	{-1, 0}, -- LEFT
}

--[[
	@brief		Executes the dashing spell
	@details	Casts the dashing spell by getting the direction of the
				the player then moving them tile-by-tile until all of the
				moves have been used or an immpassible tile is in front of
				the creature. 
	@param		creature:	The creature who is dashing
	@parama		variant:	Variant of the creature who is dashing
	@retval		None
]]
function onCastSpell(creature, variant)
	-- Get the see which tiles the player can dash through
	local direction = creature:getDirection()

	-- Iterate as long as there are valid tiles are in front of the creature
	for i = 1, TILE_LIMIT do 
		-- Get the position of the creature and find the tile they are targeting
		local position = creature:getPosition()
		 targetTile = {
			x = position.x + DIRECTION_TRANSFORMS[direction+1][1], 
			y = position.y + DIRECTION_TRANSFORMS[direction+1][2],
			z = position.z
		}

		-- Check if the tile is valid
		tile = Tile(targetTile)
		if not isTileValid(tile) then
			-- Invalid tile, end dash
			creature:sendCancelMessage("You can't dash any further")
			return
		else
			-- Move the player
			creature:teleportTo(targetTile, true)
		end
	end
end


--[[
	@brief		Checks if a tile is valid
	@details	Checks whether a tile is passible or if it is nil
	@param		tile: Tile to Check
	@retval		True if the tile is valid; false otherwise
]]
function isTileValid(tile)
	if not tile then
		return false

	elseif tile:hasFlag(TILESTATE_BLOCKSOLID) or tile:hasFlag(TILESTATE_BLOCKSOLID) or tile:hasFlag(TILESTATE_FLOORCHANGE) then
		return false

	else
		return true
	end
end