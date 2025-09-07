// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
 
contract Consumer{
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

 contract SmartContractWallet {
    //ウォレットのコントラクトではownerが資金を管理する可能性が高いので、payableで宣言しておく。
    //address payableで宣言することで、transfer(), send(), call{value: amount}()のメソッドが利用できるようになる。
    address payable public owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;
 
    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;
    
    //constructorのmsg.senderはコントラクトをデプロイした人。
    //その人がオーナーになる。
    //Ownerを上で、address payableで型宣言しているので、payableでキャストしないとエラーが出る。
    constructor() {
        owner = payable(msg.sender);
    }
    
    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "you are not the owner, aborting");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You are no guardian of this wallet, aborting");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted, aborting");
        if(_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }
 
        guardiansResetCount++;
 
        if(guardiansResetCount >= confirmationsFromGuardiansForReset) {
            owner = nextOwner;
            //nexrOwnerを初期化しておく。
            nextOwner = payable(address(0));
        }
    }
    
    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "You are not the owner, aborting!");
        allowance[_for] = _amount;
        
        if(_amount > 0){
            isAllowedToSend[_for]=true;
        }else{
            isAllowedToSend[_for] = false;
        }
    }
 
    function denySending(address _from) public {
        require(msg.sender == owner, "You are not the owner, aborting!");
        isAllowedToSend[_from] = false;
    }
 
    function transfer(address payable _to, uint _amount, bytes memory payload) public returns (bytes memory) {
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting.");
        if(msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send any transactions, aborting");
            require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to, aborting");
            allowance[msg.sender] -= _amount;
 
        }
        //Solidityの低レベルccllを用いて、payloadに関数のシグネチャとパラメータがエンコードされているならその関数を実行
        //payloadに相当する関数をReceive側が持っていなくてもTransferは成功する仕様になっている。
        (bool success, bytes memory returnData) = _to.call{value: _amount}(payload);
        require(success, "Transaction failed, aborting");
        return returnData;
    }
 
    //receive関数は、Solidityの組み込み関数であり、コントラクトがETHを受け取ると自動的に呼び出される。
    //receiveでETHを受け取ることができるようにするために、payableで定義されている。
    receive() external payable {}
}