const RockPaperScissorsFabric = artifacts.require("RockPaperScissorsFabric");

module.exports = function (deployer) {
  deployer.deploy(RockPaperScissorsFabric);
};