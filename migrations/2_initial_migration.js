const ZeeTocken = artifacts.require("ZeeTocken");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ZeeTocken);
};
