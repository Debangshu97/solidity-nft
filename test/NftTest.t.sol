// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployNft} from "../script/DeployNft.s.sol";
import {Nft} from "../src/Nft.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintNft} from "../script/Interactions.s.sol";

contract BasicNftTest is StdCheats, Test {
    string constant NFT_NAME = "Anime-Man";
    string constant NFT_SYMBOL = "AN";
    Nft public basicNft;
    DeployNft public deployer;
    address public deployerAddress;

    string public constant NFT_URI =
        "ipfs://bafybeid765hfm7mcyoyczdwcn222sj5pchotcyd6pqeu56ntvhduhybrju/?filename=0-nft.json";
    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployNft();
        basicNft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(
            keccak256(abi.encodePacked(basicNft.name())) ==
                keccak256(abi.encodePacked((NFT_NAME)))
        );
        assert(
            keccak256(abi.encodePacked(basicNft.symbol())) ==
                keccak256(abi.encodePacked((NFT_SYMBOL)))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(NFT_URI);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(NFT_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(NFT_URI))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintNft mintBasicNft = new MintNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(basicNft.getTokenCounter() == startingTokenCount + 1);
    }

    
}