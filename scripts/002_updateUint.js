(async() => {
    //web3.jsを通じて、コントラクトと通信するためには、コントラクトのアドレスと、ABIが必要である。
    //コントラクトのアドレスは、ブロックチェーン上のコントラクトの位置を特定し、通信するために必要。
    const address = "0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B"; 
    //ABIは、どの関数が存在するか、パラメータの型、呼び出し方法を定義しておく必要がある。
    const abiArray = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_newUint",
				"type": "uint256"
			}
		],
		"name": "setMyUint",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "myUint",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

    const contractInstance = new web3.eth.Contract(abiArray, address);

    console.log(await contractInstance.methods.myUint().call()) ;

    let accounts = await web3.eth.getAccounts();
    let txResult = await contractInstance.methods.setMyUint(345).send({from: accounts[0]})

    console.log(await contractInstance.methods.myUint().call());
    console.log(txResult);
})()

