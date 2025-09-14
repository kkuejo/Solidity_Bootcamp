// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

//https://docs.openzeppelin.com/contracts/5.x/wizard のWizardを用いると、ERC721のNFTのコントラクトを簡単に作成することができる。
//https://sepolia.etherscan.io/tx/0x98d74cc75eff4eaf9d5d092c6bfe05d36f6fb940c06d70f9e642253bf93cce1c にデプロイを確認。
//safemintをもちいて、URIに"spacebear_1.json"という形でミントを行う。https://sepolia.etherscan.io/token/0x6079c3db54aa663d068c4bf2dbb2036e15421259 にtokenIDが0のNFTがあることを確認。
//すると、tokenURIは、https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_1.jsonとなり、ここにNFTのメタデータが保存されている。
//メタマスクに、NFTが見えるようになったことを確認。https://testnet.rarible.com/ にメタマスクをつないで、NFTを確認。

//Spacebear Contractは、ERC721, ERC721URIStorage, Ownableを継承している。
contract Spacebear is ERC721, ERC721URIStorage, Ownable {
    //_nextTokenIdは、次のトークンIDを表す。
    uint256 private _nextTokenId;

    //initialOwnerは、コントラクトをデプロイした人のアドレスを表す。
    //デプロイ時に、initialOwnerを指定する必要がある。
    //デプロイ時に、initialOwnerの引数を受け取るために、SpacebearコントラクトのConstructorにinitialOwnerを引数として受け取るようにする。
    constructor(address initialOwner)
        ERC721("Spacebear", "SBR")
        Ownable(initialOwner)
    {}

    //_baseURIは、NFTのベースURIを表す。
    //ベースURIは、NFTのメタデータ（画像、名前、説明など）が保存されている場所の基本URLである。
    function _baseURI() internal pure override returns (string memory) {
        return "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/";
    }

    //safeMintは、NFTをmintする関数である。
    //toは、NFTを受け取る人のアドレスを表す。uriは、NFTのメタデータのURLを表す。
    //onlyOwnerは、Ownerのみが実行できるようにするためのModifierである。
    //返り値は、発行されたNFTのIDが、uint256型で返ってくる。
    function safeMint(address to, string memory uri)
        public
        onlyOwner
        returns (uint256)
    {
        //後置インクリメントを使っており、①_nextTokenIdを返してから、②_nextTokenIdをインクリメントする。
        //ちなみに、前置きインクリメントを使い、 uint256 tokenId = ++_nextTokenId;とすると、①_nextTokenIdをインクリメントしてから、tokenIdを返す。
        uint256 tokenId = _nextTokenId++;
        //_safeMintは、NFTをmintする関数である。ERC721より継承している。
        //toは、NFTを受け取る人のアドレスを表す。tokenIdは、NFTのIDを表す。
        //_safeMintは、受取先のコントラクトアドレスが、ERC721Receiverを実装いていないと失敗するようにできている。
        //これが、_safeMintと_mintの違いである。
        _safeMint(to, tokenId);
        //_setTokenURIは、NFTのメタデータのURLを設定する関数である。ERC721URIStorageより継承している。
        //tokenIdは、NFTのIDを表す。uriは、NFTのメタデータのURLを表す。
        //各トークンのURIを、_tokenURIs[i]="https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/i"のような形で設定する。
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    // The following functions are overrides required by Solidity.
    // ERC721URIStorageはERC721を抽象コントラクトとして継承している。
    //overrideは、ERC721とERC721URIStorageの両方の同じ名前の関数をオーバーライドしているが、実際にはERC721の実装が仕様されていることになる。
    //ERC721でtokenURI関数はVirtual関数として、実装されている為、オーバーライドすることができる。
    //overrideせずに、親コントラクトのtokenURI関数を呼び出すこともできるが以下の理由により、overrideすることが推奨される。
    //1. 継承の競合の解決: 複数の親クラスで同名の関数がある場合には、明示的にオーバーライドを指定する必要がある。ERC721とERC721URIStorageの両方に存在。
    //2. 型安全性の確保: コンパイル時に型をチェックし、同名の関数が複数存在することを認識しておく。
    //3. 将来の拡張性: tokenURI関数が親関数に1つしかなければ問題ないが、ERC721URIStorageに追加の機能を追加した場合に、複数のコントラクトにtokenURI関数が存在し、競合することとなる。その準備として、最初からoverrideしておく。
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        //overrideした親コントラクトの関数を呼び出す場合には、super.を使う。
        return super.tokenURI(tokenId);
    }

    //利用できる関数を確認する機能。
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}