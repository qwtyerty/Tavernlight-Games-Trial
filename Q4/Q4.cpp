// Explanation: The memory leaks come from the player objects created from the
//				new keyword with out being deleted at the end of the function.
//				Additionally, depending on how the player parameter is passed
//				it may also need to be deleted. In addition to being deleted the
//				pointer can be set to null in order to prevent it being accessed
//				after  deletion.

// NOTE: Depending by assumptions made the cleanUpPlayer function, the deletion of 
// the player object can vary depending on how g_game.getPlayerByName creates the 
// instance of the player object. While likely that g_game.getPlayerByName creates 
// a new instance dynamically, I have included two helper functions for each situation
// and will be labelled as Dynamic for the case where it is assumed to be, and the other
// will not exlude a label

/**
 *	@brief		Cleans up the player pointer (DYNAMIC ASSUMPTION)
 *	@details	Checks whether the player has been dynamically loaded
 *				via a flag, then delete the player pointer, and set
 *				it to nullptr
 *	@param		@ref player:					Pointer to a player instance
 *	@param		@ref playerLoadedDynamically:	Flag indicating whether the
 *					palyer was loaded dynamically using the new keyword
 *	@retval		None
 */
void cleanUpPlayerDynamic(Player* player)
{
	// Delete the player and set the pointer to NULL
	delete player;
	player = NULL;
}

/**
 *	@brief		Adds an item to the recipient (DYNAMIC ASSUMPTION)
 *	@details	Adds an item with itemId @ref itemId to the player with
 *				the name @ref recipient
 *	@param		@ref recipient:	Name of the recipient of the item
 *	@param		@ref itemId:	Item id of the item to add
 *	@retval		None
 */

void Game::addItemToPlayerDynamic(const std::string& recipient, uint16_t itemId)
{

	Player* player = g_game.getPlayerByName(recipient);

	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			
			// Unable to find player, delete pointer to player, and set to NULL just in case
			cleanUpPlayerDynamic(player);
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		// Failed to create item, delete pointer to player
		cleanUpPlayerDynamic(player);
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}

	cleanUpPlayerDynamic(player);
}


/**
 *	@brief		Cleans up the player pointer (STATIC ASSUMPTION)
 *	@details	Checks whether the player has been dynamically loaded
 *				via a flag, then delete the player pointer, and set
 *				it to nullptr
 *	@param		@ref player:					Pointer to a player instance
 *	@param		@ref playerLoadedDynamically:	Flag indicating whether the
 *					palyer was loaded dynamically using the new keyword
 *	@retval		None
 */
void cleanUpPlayer(Player* player, bool playerLoadedDynamically)
{
	// Only delete if the new operator has been used
	if (playerLoadedDynamically)
	{
		delete player;
		player = nullptr;
	}
}

/**
 *	@brief		Adds an item to the recipient (STATIC ASSUMPTION)
 *	@details	Adds an item with itemId @ref itemId to the player with
 *				the name @ref recipient
 *	@param		@ref recipient:	Name of the recipient of the item
 *	@param		@ref itemId:	Item id of the item to add
 *	@retval		None
 */

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{

	Player* player = g_game.getPlayerByName(recipient);


	// Store a flag of whether the player is loaded statically
	bool playerLoaded = player;

	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {

			// Unable to find player, delete pointer to player, and set to NULL just in case
			cleanUpPlayer(player, !playerLoaded);
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		// Failed to create item, delete pointer to player
		cleanUpPlayer(player, !playerLoaded);
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}

	cleanUpPlayer(player, !playerLoaded);
}