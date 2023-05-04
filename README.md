<h1> Wopajes 2 DApp (made with Hardhat + Rainbow + wagmi + Next.js) </h1>
![image](https://user-images.githubusercontent.com/113106548/236301033-0629428e-d3bf-418b-bf67-edcd912dea6c.png)


<br> 

<h2> Backend (In hardhat folder). </h2>

Contains smart contract with two mint functions, one for the existing Wojape 1 holders to redeem their NFTs and mint 4 Wojapes 2. Smart contract automatically parses through Wojapes 1 ID's so no reentries or double minting is possible. Second mint function for WL addresses, with Merkle Tree functionality. Any additional functionality like burning is possible to add.

<br> 

<h2> Frontend (In dapp folder). </h2>

Contains basic functionality for frontend and design. DApp automatically parses wojapes 1 ID's through wagmi hooks during the holders mint, so no additional actions are required from the minter. During the WL mint DApp automatically rebuilds Merkle Tree with the minters proof to confirm WL membership. DApp uses Rainbow wallet plugin and automatically displays UI elements depending on the phase of the mint, which it checks with wagmi hooks.
