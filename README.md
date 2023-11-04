# Heads or Tails Blockchain Game

Welcome to the Heads or Tails blockchain game, a simple and entertaining betting game built on the Aleo platform. This game leverages the privacy features of Aleo to ensure a fair and secure gaming experience.

## Introduction

Players can participate in a virtual coin toss game where they bet an amount of tokens on either heads or tails. The game is deterministic and the outcome is based on pseudo-random number generation within the smart contract.

## Features

- **Token Distribution**: Players can claim tokens to participate in the game.
- **Betting System**: Users can bet on the outcome of a coin toss.
- **Fair Outcome**: The game uses cryptographic functions to ensure a fair outcome.
- **Reward System**: Winners receive twice the amount of their bet.

## Smart Contract Structures

- `GameToken`: Manages the tokens owned by a player within the game.
- `GameSession`: Represents a game round with all associated details.
- `userBalances`: Tracks the balance of each player.
- `gameSessions`: Stores ongoing game sessions.

## How to Interact with the Contract

1. **Claim Initial Tokens**:

   - New players are entitled to an initial token balance to get started.
   - `transition claim_tokens() -> GameToken;`

2. **Initiate a Game Session**:

   - Players choose their bet and predict the outcome.
   - `transition initiateGameSession(public sessionID: field, choice: u8, betAmount: u64);`

3. **Play the Game**:
   - The game resolves and determines if the player's guess was correct.
   - `transition playGame(sessionID: field) -> field;`

## Getting Started

To interact with this smart contract, you need to have the Aleo SDK installed.

### Prerequisites

- Install [Aleo SDK](https://developer.aleo.org/developer/getting_started/installation)

### Installation

1. Clone the repository:

```shell
git clone https://github.com/DyxaDevelop/headsortails.aleo
```

2. Navigate to the repository directory:

```shell
cd [repository name]
```

3. Compile the contract using Aleo CLI:

```shell
leo run build
```

4. Deploy the contract to the Aleo network following the Aleo documentation.
