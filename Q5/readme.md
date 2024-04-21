This task was to reproduce a spell effect creating ice tornadoes arround the player whenever the player casts the spell by saying "frigo".

This was accomplished by adding a new spell with an unused id of 179 into the attack section of spells.xml to register the spell and then implementing the functionality of the spell in ice_tornado.lua.
For the implementation of the ice tornado effect the damage patterns are defined and iterated through.
