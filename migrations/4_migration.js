const ZeeTockenC = artifacts.require("ZeeTockenC");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ZeeTockenC);
};
