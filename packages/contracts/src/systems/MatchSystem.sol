// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {System} from "@latticexyz/world/src/System.sol";
import {joinQueue, leaveQueue, createMatch} from "../libraries/LibMatch.sol";
import {Entity} from "../Entity.sol";

contract MatchSystem is System {
    function searchMatch(Entity map) external {
        // TODO: check if map exists
        joinQueue(_msgSender(), map);
    }

    function leaveSearch() external {
        leaveQueue(_msgSender());
    }

    function settleMatch(Entity mapEntity, address[4] memory players) external {
        createMatch(mapEntity, players, 50, 0, 0);
    }
}
