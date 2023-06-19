// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Nft} from "../src/Nft.sol";


contract MintNft is Script {
    string public constant NFT_URI =
        "ipfs://bafybeid765hfm7mcyoyczdwcn222sj5pchotcyd6pqeu56ntvhduhybrju/?filename=0-nft.json";
    uint256 deployerKey;

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("Nft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNftOnContract(address basicNftAddress) public {
        vm.startBroadcast();
        Nft(basicNftAddress).mintNft(NFT_URI);
        vm.stopBroadcast();
    }
}



