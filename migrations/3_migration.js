const ZeeTockenB = artifacts.require("ZeeTockenB");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ZeeTockenB);
};
