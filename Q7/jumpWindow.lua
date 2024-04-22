--[[
	@brief		Creates a window with a button that scrolls to the left
	@details	Creates a small moveable window with a button that scrolls to the
					left until hitting the left side of the window, whenever the button
					is pressed or the left side is hit the button's position is reset 
					to a default x position and a random y position
]]

-- Game window and button instances
gameWindow = nil
jumpButton = nil

-- Module for all class specific functions
JumpGame = {}

-- Controls the tick rate and move rate
local tickSpeed = 50
local moveSpeed = 5

-- The position of the window and relevant maximums
local windowPos = nil
local maximumXPos = nil
local maximumYPos = nil

-- An x position value relative to the inside of the 
-- window so the window can be in an position and this value 
-- remains unchanged
local localXPos = 0

local btn_width = nil
local btn_height = nil


--[[
	@brief		Updates the position of the button
	@details	Updates the position of the jump button by moving 
				@ref the localXTarget checking it is within bounds then applying the move
				with the global position of the button (window x + local x) then updating
				the local value. Once the left side is reached (half of the button width)
				the button's position is reset. After either occurs then next update call
				is scheduled to cause an update @ref tickSpeed ms later.
	@retval		NOne
]]
function update()
	--Verify that jumpButton has not been destroyed
	if not jumpButton then
		return
	end

	-- Get the latest position of the window
	windowPos = gameWindow:getPosition()

	-- Calcuate the next position and check if it is OOB
	localXTarget = localXPos - moveSpeed
	if localXTarget > btn_width/2 then
		-- Update the possition of the button globally and Update
		-- the local counterpart
		jumpButton:setX(windowPos.x + localXTarget)
		localXPos = localXTarget
	else
		-- Button is OOB reset the position
		resetButtonPosition()
	end

	-- Schedule the next update call
	scheduleEvent(update, tickSpeed)
end

--[[
	@brief		Initializes the module
	@details	Initalizes the module by binding the JumpGame.init to onLogin
				so that the window appears as soon as a player logs into a 
				server, and bind onLogout so the window is terminated once logout
				occurs.
]]
function init()
	connect(g_game, {onLogin = JumpGame.init,
						onLogout = JumpGame.terminate})
end

--[[
	@brief		Terminates the module
	@details	Terminates the module by unbinding the JumpGame.init to onLogin
				and unbinding onLogout so the window is terminated once logout
				occurs. Then cleans up by setting JumpGame and JumpButton to nil
]]
function terminate()
	disconnect(g_game, {onLogin = JumpGame.init,
						onLogout = JumpGame.terminate})
	JumpGame = nil
	jumpButton = nil
end

--[[
	@brief		Initializes the module
	@details	Initializes the module by creating the gameWindow and Button
				and defining default values, before resetting the button's position
				and starting the update loop.
]]
function JumpGame.init()
	-- Assign instances
	gameWindow = g_ui.displayUI('jumpWindow.otui')
	jumpButton = gameWindow:recursiveGetChildById('jumpBtn')
	btn_width = jumpButton:getWidth()
	btn_height = jumpButton:getWidth()

	-- Update maximums and set pos
	maximumXPos = gameWindow:getWidth() - btn_width
	localXPos = maximumXPos
	maximumYPos = gameWindow:getHeight() - 2 * btn_height 
	resetButtonPosition()

	-- Start the update callback loop
	update()
end

--[[
	@brief		Terminates the module
	@details	Terminates the module by destroying the gameWindow
]]
function JumpGame.terminate()
	gameWindow:destroy()
	return
end

--[[
	@brief		Resets the button's position
	@details	Resets the button's position to a fixed local x value and
				resets the local y value to a random value within the window
				and updates the button's globally
]]
function resetButtonPosition()

	if not (jumpButton and gameWindow) then
		return
	end

	-- Get the current window position
	windowPos = gameWindow:getPosition()

	-- Generate a random local Y value, then update both
	-- local and global position values for the button
	nextY = math.random(btn_width, maximumYPos)
	jumpButton:setX(maximumXPos + windowPos.x)
	jumpButton:setY(windowPos.y + nextY)
	localXPos = maximumXPos
end

--[[
	@brief		Resets the button when clicked
	@details	Resets the button when clicked
]]
function JumpGame.onClick()
	resetButtonPosition()
end
