// The 'headsortails' program.
program headsortails.aleo {

    // Define a structure for an internal game token with an associated owner and amount.
    struct GameToken {
        owner_contract: address,
        amount: u64,
    }
    
    // A mapping to keep track of user balances indexed by address.
    mapping userBalances: address => u64;

    // Define a structure representing the state of a single Heads or Tails game session.
    struct GameSession {
        player: address,       // The address of the player participating in the session.
        bet_amount: u64,        // The amount of currency bet in the game.
        player_choice: u8,      // The player's choice: 0 for Heads or 1 for Tails.
        result: u8,            // The result of the game: 0 for Heads or 1 for Tails.
        has_won: bool,          // Flag to indicate if the player has won the game.
    }

    // A mapping to keep track of game sessions indexed by a unique field.
    mapping gameSessions: field => GameSession;

    // Function for players to claim initial game tokens.
    transition claim_tokens() -> GameToken {
        let initial_tokens: u64 = 1000u64; // The initial number of tokens to give to a user.
        let user_address: address = self.caller; // The address of the user claiming the tokens.

        // Return a new GameToken for the caller with the initial amount.
        return GameToken {
            owner_contract: self.caller,
            amount: initial_tokens,
        } then finalize (initial_tokens, user_address); // Proceed to finalize with given tokens and user address.
    }

    // Finalize the token claim and update the user's balance in the mapping.
    finalize claim_tokens(initial_tokens: u64, user_address: address) {
        Mapping::set(userBalances, user_address, initial_tokens); // Update the user's balance in the mapping.
    }

    // Function to initiate a new game session.
    transition initiateGameSession(public sessionID: field, choice: u8, bet_amount: u64) {
        assert(bet_amount > 0u64); // Ensure the bet amount is greater than zero.
        assert(choice == 0u8 || choice == 1u8); // Ensure the choice is valid (0 or 1).

        // Set up a new game session with the provided details.
        let new_session: GameSession = GameSession {
            player: self.caller,
            bet_amount: bet_amount,
            player_choice: choice,
            result: 0u8, // Result is initially 0, will be set later.
            has_won: false, // Initially, the player has not won.
        };

        // Proceed to finalize the game session with the new session details.
        return then finalize (sessionID, new_session, bet_amount);
    }

    // Finalize the initiation of a game session.
    finalize initiateGameSession(sessionID: field, new_session: GameSession, bet_amount: u64) {
        let player_balance: u64 = Mapping::get(userBalances, new_session.player); // Get the player's current balance.
        assert(player_balance >= bet_amount); // Ensure the player has sufficient balance to place the bet.

        // Deduct the bet amount from the player's balance and update it.
        let new_balance: u64 = player_balance - bet_amount;
        Mapping::set(userBalances, new_session.player, new_balance);

        // Save the new game session into the mapping.
        Mapping::set(gameSessions, sessionID, new_session);
    }

    // Function to play the game using a specified session ID.
    transition playGame(sessionID: field) -> field {
        // The actual gameplay logic will be handled in the finalize block.
        // This placeholder simply forwards the session ID to the finalize block.
        return then finalize (sessionID);
    }

    // Finalize the game play by determining the outcome of the game session.
    finalize playGame(sessionID: field) {
        let session: GameSession = Mapping::get(gameSessions, sessionID); // Retrieve the game session.
        
        // Generate a random value to simulate a coin toss.
        let randomValue: u8 = ChaCha::rand_u8();
        let coinTossResult: u8 = randomValue % 2u8; // The result is either 0 or 1, simulating Heads or Tails.

        // Update the session with the result and whether the player has won.
        let updated_session: GameSession = GameSession {
            player: session.player,
            bet_amount: session.bet_amount,
            player_choice: session.player_choice,
            result: coinTossResult,
            has_won: session.player_choice == coinTossResult, // Determine if the player's choice matches the result.
        };

        // Adjust the player's balance if they won.
        let player_balance: u64 = Mapping::get(userBalances, session.player);

        let new_balance: u64 = 0u64;

          if session.has_won {
            new_balance = player_balance + (session.bet_amount * 2u64); // Double the bet amount if the player won.
            Mapping::set(userBalances, session.player, new_balance);
          } 
          

        // Update the game session in the mapping to reflect the outcome.
        Mapping::set(gameSessions, sessionID, updated_session);
    }
}
