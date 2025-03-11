// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import {MudTest} from "@latticexyz/world/test/MudTest.t.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";

contract PepemateTest is MudTest {
    IWorld world;
    uint256 userNonce = 0;

    address payable playerA;
    address payable playerB;
    address payable playerC;
    address payable playerD;

    bytes32 testMatch;

    function setUp() public override {
        super.setUp();
        world = IWorld(worldAddress);

        vm.startPrank(address(0));
        vm.stopPrank();

        playerA = getUser();
        playerB = getUser();
        playerC = getUser();
        playerD = getUser();
    }

    function getUser() internal returns (address payable) {
        address payable user = payable(address(uint160(uint256(keccak256(abi.encodePacked(userNonce++))))));
        vm.deal(user, 100 ether);
        return user;
    }

    modifier prank(address target) {
        vm.startPrank(target);
        _;
        vm.stopPrank();
    }
    
    // modifier adminPrank() {
    //   vm.startPrank(NamespaceOwner.get(ROOT_NAMESPACE_ID));
    //   _;
    //   vm.stopPrank();
    // }

    // function prankAdmin() internal {
    //   vm.startPrank(NamespaceOwner.get(ROOT_NAMESPACE_ID));
    // }
}