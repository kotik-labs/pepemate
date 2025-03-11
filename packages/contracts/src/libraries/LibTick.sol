// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {Tick} from "../codegen/index.sol";
import {MAX_TICKS_PER_BLOCK, MAX_TICK_BLOCK_DELAY} from "../constants.sol";
import {Entity} from "../Entity.sol";

function updateTick(Entity entity, uint32 tickCost) {
    uint32 blockNumber = uint32(block.number);
    (uint32 lastBlock, uint32 count) = Tick.get(entity);

    bool init = count == 0 && lastBlock == 0;
    bool refresh = blockNumber > lastBlock + MAX_TICK_BLOCK_DELAY;

    if (init || refresh) {
        // reset tick counter in next blocks
        Tick.set(entity, blockNumber, MAX_TICKS_PER_BLOCK);
        return;
    }

    require(count >= tickCost, "Tick blocked");
    Tick.setCount(entity, count - tickCost);
}
