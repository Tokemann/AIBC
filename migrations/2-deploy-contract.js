var GenesisContract = artifacts.require("GenesisContract");
var MyTcErc20=artifacts.require("MyTcErc20");

module.exports = function(deployer) {
  deployer.deploy(GenesisContract);
  deployer.deploy(MyTcErc20);
};