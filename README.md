# Convertible ERC Tokens
*A set of contracts to convert ERC20/721/1155 tokens to a loot box ERC721 token. The loot box token can then be opened to a rewarding ERC721 token at a randomizer logic. The randomized rewarding token has a rarity level.*

 1. RewardERC721: The token that is rewarded to the loot box opener. Currently only holds logic to specify the color that is assigned to the rewarded token.
 2. LootBoxERC721: The loot box token which can be opened at a later time. The main functionality is in `unpack()` function where the contract randomizes the odds and depending on the randomizer output, gives a certain color of RewardERC721 token to the opened. The colors rarity is ass follows:
	 - Blue color which has 10% chances
	 - Green color which as 10% chances
	 - Red color which has 50% chances
	 - Orange color which has 30% chances
 3. LootBoxBuyer: This contract takes ERC20/721/1155 tokens at a predefined rate to reward one LootBox to the sender and return its address to open at a later time.