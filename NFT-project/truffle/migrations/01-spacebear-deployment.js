const Spacebear = artifacts.require("Spacebear");

module.exports = function(deployer, network, accounts) {
    // デプロイ時にinitialOwnerを指定する必要があります
    // accounts[0]はデプロイに使用されるアカウント（通常は最初のアカウント）
    console.log(network,accounts[0]);
    deployer.deploy(Spacebear, accounts[0]);
};