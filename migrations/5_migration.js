const ZeeNFT = artifacts.require("ZeeNFT");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ZeeNFT);
};
