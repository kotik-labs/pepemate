// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {Entity} from "./Entity.sol";
import {EntityCounter} from "./codegen/index.sol";

function createEntity() returns (Entity) {
    uint32 entityIndex = EntityCounter.get() + 1;
    EntityCounter.set(entityIndex);
    return Entity.wrap(bytes32(uint256(entityIndex)));
}
