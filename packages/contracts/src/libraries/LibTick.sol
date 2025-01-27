// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import {LastBlock, TickCount} from "../codegen/index.sol";
import {MAX_TICKS_PER_BLOCK, MAX_TICK_BLOCK_DELAY} from "../constants.sol";

library LibTick {
    function update(bytes32 entity, uint32 tickCost) internal {
        uint32 blockNumber = uint32(block.number);
        uint32 lastBlock = LastBlock.get(entity);
        uint32 count = TickCount.get(entity);

        bool init = count == 0 && lastBlock == 0;
        bool refresh = blockNumber > lastBlock + MAX_TICK_BLOCK_DELAY;

        if (init || refresh) {
            // reset tick counter in next blocks
            TickCount.set(entity, MAX_TICKS_PER_BLOCK);
            LastBlock.set(entity, blockNumber);
            return;
        }

        require(count >= tickCost, "Tick blocked");
        TickCount.set(entity, count - tickCost);
    }
}
