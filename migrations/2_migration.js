const ZeeTockenA = artifacts.require("ZeeTockenA");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ZeeTockenA);
};
