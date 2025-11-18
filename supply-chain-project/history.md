1. # Foundryプロジェクト初期化
    forge init contracts
    cd contracts

2. # OpenZeppelinのインストール
    2.1 forge install OpenZeppelin/openzeppelin-contracts
    2.2 foundry.tomlに記述
        [profile.default]
    src = "src"
    out = "out"
    libs = ["lib"]
    solc_version = "0.8.20"
    remappings = [
        "@openzeppelin/=lib/openzeppelin-contracts/"
    ]

3. " foundry.