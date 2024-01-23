program headsortails.aleo;

struct GameToken:
    owner_contract as address;
    amount as u64;

struct GameSession:
    player as address;
    bet_amount as u64;
    player_choice as u8;
    result as u8;
    has_won as boolean;


mapping userBalances:
	key as address.public;
	value as u64.public;


mapping gameSessions:
	key as field.public;
	value as GameSession.public;

function claim_tokens:
    cast self.caller 1000u64 into r0 as GameToken;
    async claim_tokens 1000u64 self.caller into r1;
    output r0 as GameToken.private;
    output r1 as headsortails.aleo/claim_tokens.future;

finalize claim_tokens:
    input r0 as u64.public;
    input r1 as address.public;
    set r0 into userBalances[r1];


function initiateGameSession:
    input r0 as field.public;
    input r1 as u8.private;
    input r2 as u64.private;
    gt r2 0u64 into r3;
    assert.eq r3 true;
    is.eq r1 0u8 into r4;
    is.eq r1 1u8 into r5;
    or r4 r5 into r6;
    assert.eq r6 true;
    cast self.caller r2 r1 0u8 false into r7 as GameSession;
    async initiateGameSession r0 r7 r2 into r8;
    output r8 as headsortails.aleo/initiateGameSession.future;

finalize initiateGameSession:
    input r0 as field.public;
    input r1 as GameSession.public;
    input r2 as u64.public;
    get userBalances[r1.player] into r3;
    gte r3 r2 into r4;
    assert.eq r4 true;
    sub r3 r2 into r5;
    set r5 into userBalances[r1.player];
    set r1 into gameSessions[r0];


function playGame:
    input r0 as field.private;
    async playGame r0 into r1;
    output r1 as headsortails.aleo/playGame.future;

finalize playGame:
    input r0 as field.public;
    get gameSessions[r0] into r1;
    rand.chacha into r2 as u8;
    rem r2 2u8 into r3;
    is.eq r1.player_choice r3 into r4;
    cast r1.player r1.bet_amount r1.player_choice r3 r4 into r5 as GameSession;
    get userBalances[r1.player] into r6;
    mul r1.bet_amount 2u64 into r7;
    add r6 r7 into r8;
    set r8 into userBalances[r1.player];
    ternary r1.has_won r8 0u64 into r9;
    set r5 into gameSessions[r0];
