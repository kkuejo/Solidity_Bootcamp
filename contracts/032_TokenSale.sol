//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
 
 //ERC20トークンの規格は、https://ethereum.org/ja/developers/docs/standards/tokens/erc-20/ で確認可能。

//AがSampleTokenをデプロイし、BにCoffeeTokenを1000枚ミントした。
//Bは、TokenSaleコントラクトをデプロイし、その際にSampleTokenのコントラクトアドレスを_tokenに渡している。
//Bは、SampleTokenのApprove機能で、TokenSaleコントラクトに対し、1000枚の利用許可を与える。
//Cが、SampleTokenのpurchase機能で、1ETHを支払うと、1枚のCoffeeTokenを購入することができる。

//abstract contactは、デプロイされるコントラクトの型の定義としてのみ機能し、実際にデプロイされるのはTokenSaleコントラクトのみである。
abstract contract ERC20{
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function decimals() public virtual view returns(uint8);
}

 
//TokenSaleのスマートコントラクトで、ETHを支払ってERC20トークンを購入する物です。

contract TokenSale {
  
    uint public tokenPriceInWei = 1 ether;
    
    //抽象コントラクトERC20を型として仕様している。
    //抽象コントラクトを型として仕様することで、TokenSaleコントラクトは、ERC20の機能を利用することができる。                                                                             
    ERC20 public token;
    address public tokenOwner;
    
    //コントラクトをデプロイした人がtokenOwnerとなる。
    //_tokenは、ERC20トークンのアドレスを受け取る。
    constructor(address _token) {
        tokenOwner = msg.sender;
        //_tokenのアドレス型(コントラクト)をERC20型の抽象コントラクトにキャストしている。
        //キャストすることで、tokenは_tokenの機能が持つフル機能でなく、抽象コントラクトで定義された機能のみを利用することができる。
        //機能を制限する理由はには以下のようなものが考えられる。
        //1. セキュリティの向上：不要な関数へのアクセスを防止
        //2. コントラクトのサイズの削減：不要な機能を削除することで、コントラクトのサイズを削減する。
        //3. 意図しない操作の防止：危険な関数の実行を防止
        //4. 明確な責任分離：TokenSaleの責任を明確化
        //5. 保守性の向上: 変更の影響範囲を限定
        token = ERC20(_token);
    }
 
    function purchase() public payable {
        require(msg.value >= tokenPriceInWei, "Not enough money sent");
        uint tokensToTransfer = msg.value / tokenPriceInWei;
        uint remainder = msg.value - tokensToTransfer * tokenPriceInWei;
        token.transferFrom(tokenOwner, msg.sender, tokensToTransfer * 10 ** token.decimals());
        payable(msg.sender).transfer(remainder); //send the rest back
 
    }
}