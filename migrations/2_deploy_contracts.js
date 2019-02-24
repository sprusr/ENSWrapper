var ENSWrapper = artifacts.require("./ENSWrapper.sol");

module.exports = function(deployer) {
  deployer.deploy(ENSWrapper, "ENS Token", "ENS", "0x0000000000000000000000000000000000000000");
};
