const RockPaperScissorsFabric = artifacts.require("RockPaperScissorsFabric");
const RockPaperScissors = artifacts.require("RockPaperScissors");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("RockPaperScissorsFabric", accounts => {

  let actions = ["ROCK", "PAPER", "SCISSORS"];
  let hashed_actions = actions.map(action => web3.utils.keccak256(web3.utils.encodePacked(action)))

  let player1 = accounts[1];
  let player2 = accounts[2];

  it("should allow player2 to win the game by looking at player1 commitment", async function () {
    await RockPaperScissorsFabric.deployed()
    .then(instance => { 
      gameAddress = instance.newGame.call(player1, player2, 200, {from: accounts[0]});
      instance.newGame.sendTransaction(player1, player2, 200, {from: accounts[0]});
      return gameAddress; })
    .then(async gameAddress => {return await RockPaperScissors.at(gameAddress);})
    .then(async gameInstance => {
      await gameInstance.fundGame.sendTransaction({from: player1, value: 200});
      await gameInstance.fundGame.sendTransaction({from: player2, value: 200});
      return gameInstance;})
    .then(async gameInstance => {
      let res = await gameInstance.currentState.call();
      // GameState must be COMMITMENT
      assert(res.eq(web3.utils.toBN(1)));
      return gameInstance;
    })
    .then(async gameInstance => {
      let rand = Math.floor(Math.random() * actions.length);
      await gameInstance.commitToAction.sendTransaction(web3.utils.keccak256(web3.utils.encodePacked(actions[rand])), {from: player1});
      let playerState1 = await gameInstance.playerStates.call(player1);

      let action1Index = hashed_actions.indexOf(playerState1.commitment);

      assert.equal(rand, action1Index);

      let action2Index = (action1Index+1)%3;

      await gameInstance.commitToAction.sendTransaction(hashed_actions[action2Index], {from: player2});

      let res = await gameInstance.currentState.call();

      // GameState must be COMMITMENT
      assert(res.eq(web3.utils.toBN(2)));
      
      // REVEAL PHASE
      await gameInstance.reveal.sendTransaction(actions[rand], {from: player1});
      await gameInstance.reveal.sendTransaction(actions[action2Index], {from: player2});
      
      return gameInstance;
    })
    .then(gameInstance => gameInstance.winner.call().then(winner => assert.equal(winner, player2)))
  });
});
