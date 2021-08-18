const RockPaperScissors = artifacts.require("RockPaperScissors");

module.exports = function (deployer, network, accounts) {
  var _player1 = accounts[0];
  var _player2 = accounts[1];
  var _agreedStake = 200;
  deployer.deploy(RockPaperScissors, _player1, _player2, _agreedStake);
};