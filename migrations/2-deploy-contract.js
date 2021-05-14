var GenesisContract = artifacts.require("GenesisContract");
var CommunityContract=artifacts.require("CommunityContract");

module.exports = function(deployer) {
  deployer.deploy(GenesisContract);
  deployer.deploy(CommunityContract);
};