The Task was to create a window with a moving button, labelled "Jump!" that scolls across the window until it reaches the left of the screen.

This was accompilished by creating an OTClient mod that creates a OTUI window with the button controlled via lua script. The lua script makes the button's position move over time util it reaches the left side of the screen where it is reset to a default x position and random y position. 
If the button is clicked the button will be reset, similar to if it has touched the left side of the window
