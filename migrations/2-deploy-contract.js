var GenesisContract = artifacts.require("GenesisContract");
var CommunityContract=artifacts.require("CommunityContract");
var CryptoFace=artifacts.require("CryptoFace");

module.exports = function(deployer) {
  deployer.deploy(GenesisContract);
  deployer.deploy(CommunityContract);
  deployer.deploy(CryptoFace);
};