// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
//https://docs.openzeppelin.com/contracts/5.x/wizard のWizardを用いると、ERC20のコントラクトを簡単に作成することができる。
//OpenZepplineの内容は、内容はhttps://github.com/openzeppelin で確認できる。

pragma solidity ^0.8.27;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//CoffeeTokenは、ERC20とAccessControlの2つのコントラクトを継承している。
//カンマで区切ることで複数のコントラクトを継承することができる。
contract CoffeeToken is ERC20, AccessControl {

    //constantと書くことでコンパイル時に値が確定し、実行時に変更できない定数となる。これはバイトコードに埋め込まれるため、ガス効率が良い。
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    //receiverとbuyerのアドレスをindexedで指定することで、ログの検索が容易になる。
    //eventでは、CoffeePurchasedは、ブロックチェーン上に永続的に記録されることを行うのみ。
    event CoffeePurchased(address indexed receiver, address indexed buyer);

    //ERC20を継承している。
    //defaultadminとminterのアドレスを付与して、デプロイする。
    //もともと、contract CoffeeToken is ERC20, AccessControlとなっているので、Coffee Tokenは、ERC20とAccessControlの両方の機能を継承している。
    //constructor(address defaultAdmin, address minter)は、ERC20のconstructor(string memory name, string memory symbol)を継承している。
    //ERC20のconstructor(string memory name, string memory symbol)は、nameとsymbolを設定する。
    //親constructerの設定が必要な場合は必ず呼び出す必要がある。
    //ERC20("CoffeeToken", "MTK")の親constructerを呼び出したあとに、CoffeeTokenのconstructorを実行する。
    constructor(address defaultAdmin, address minter) ERC20("CoffeeToken", "MTK") {
        //defaultAdminアドレスにDEFAULT_ADMIN_ROLEの権限を付与する。
        //minterロールの付与や剥奪などができる。
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        //minterアドレスにMINTER_ROLEの権限を付与する。
        _grantRole(MINTER_ROLE, minter);
    }

    //onlyRole(MINTER_ROLE)は、Modifierで、MINTER_ROLEの権限を持つアドレスのみが関数を実行できるようにする。
    //onlyRole()は、AccessControlから継承し、_mint()はERC20から継承している。
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        //mint()は、ERC20から継承している。これにより、toのCoffeeTokenの残高をamount増やすことができる。
        _mint(to, amount * 10 ** decimals());
    }

    //buyOneCoffee()は、自分の保有するCoffeeTokenを消費して、Coffeeを1つ購入する。
    function buyOneCoffee() public {
        //_msgSender()がCoffeeを受け取る人(購入する人)のアドレスを返す。
        //_msgSender()は、ERC20にも、AccessControlにもどちらにも記載があるが、実際には先に継承されているERC20から返される。しかし、両方の実装が同じであるため問題にならない。
        //_burn()は、ERC20から継承している。これにより、CoffeeTokenの残高を1減らすことができる。
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit CoffeePurchased(_msgSender(), _msgSender());
    }

    //buyOneCoffeeFromは、accountの保有するCoffeeTokenを消費して、_msgSenderがCoffeeを1つ購入する。
    function buyOneCoffeeFrom(address account) public{
        //_SpendAllowanceは、ERC20から継承している。これにより、accountの保有するCoffeeTokenを_msgSenderが1つ消費することができる。
        //_spendAllowanceは、accountが_msgSenderに利用を許可しているToken数を確認し、その数が1以上であることを確認する。
        //ERC20を継承しているので、approve関数が利用可能で、他の人に、CoffeeTokenの利用を許可することができる。
        _spendAllowance(account, _msgSender(), 1 * 10 ** decimals());
        _burn(account, 1);
        emit CoffeePurchased(_msgSender(), account);
    }
}