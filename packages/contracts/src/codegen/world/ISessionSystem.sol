// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { Entity } from "../../Entity.sol";

/**
 * @title ISessionSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ISessionSystem {
  function pepemate__createSession(uint256 id, bytes32 mapId) external returns (Entity session);

  function pepemate__joinSession(Entity session, uint8 playerIndex) external;

  function pepemate__leaveSession() external;
}
