// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/**
 * @title LibBitmap
 * @dev Library for managing a bitmap using a uint256.
 * Provides functions to set, reset, and get the state of individual bits.
 */
library LibBitmap {
    function get(uint256 bitmap, uint256 index) internal pure returns (bool) {
        return (bitmap & (1 << index)) != 0;
    }

    function set(uint256 bitmap, uint256 index) internal pure returns (uint256) {
        return bitmap | (1 << index);
    }

    function reset(uint256 bitmap, uint256 index)
        internal
        pure
        returns (uint256)
    {
        return bitmap & ~(1 << index);
    }
}
