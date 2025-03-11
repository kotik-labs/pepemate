import { defineWorld } from "@latticexyz/world";

/// Public Session Cycle
/// create session params:
//    - init map
//    - round block delay
//    - max blocks per round
//    - default lives, firecount, bombcount
// join session:
//    - set in-queue for next round
// create round:
//    - get prev player list - define how "left" session
//    - set round data
//    - set players, add new from queue if any
//    - unfreeze movements in 2 blocks
// leave session:
//    - remove from queue
//    -
// finish round:
//    - remove round data
//    - define who is the winner
//    - defi

/// TODO:
// Battle mode: timed sessions with restart
// configurable player init setup
// spawn powerups on player death based on time/ player inventory
// Timer: shrink map based on timer
// Powerups: blast bomb, holy shield (miss death), switch players, kick bombs
// Powerups: CURSES - low range, low bombs, low stamina
// Afterdeath: throw bombs in range (2-5), jump on wall/block if hitted
// Ranked matchmaking: ranking + matchmaking keeper
// make maps size (width x height) fully configurable (min 15x15)
// Team modes: arena / team

export default defineWorld({
  namespace: "pepemate",
  deploy: {
    upgradeableWorldImplementation: true,
  },
  userTypes: {
    Entity: { type: "bytes32", filePath: "./src/Entity.sol" },
  },
  enums: {
    SessionType: ["None", "Public", "Ranked"],
    TileType: [
      "None",
      "Grass",
      "Block",
      "Wall",
      "RangeUp",
      "SpeedUp",
      "BombsUp",
      "BlastBomb",
      "HolyShield",
      "SpawnA",
      "SpawnB",
      "SpawnC",
      "SpawnD",
    ],
    EntityType: ["Player", "Bomb"],
    Direction: ["Up", "Left", "Right", "Down"],
  },
  tables: {
    /// Match Components
    MatchConfig: {
      key: ["matchEntity"],
      schema: {
        matchEntity: "Entity",
        startBlock: "uint32",
        endBlock: "uint32",
        mapId: "Entity",
      },
      codegen: { dataStruct: false },
    },

    EntityMatch: {
      key: ["entity"],
      schema: { entity: "Entity", session: "Entity" },
      codegen: { dataStruct: false },
    },

    MatchPlayers: {
      key: ["matchEntity"],
      schema: { matchEntity: "Entity", players: "bytes32[4]" },
      codegen: { dataStruct: false },
    },

    MatchHealth: {
      key: ["matchEntity"],
      schema: { matchEntity: "Entity", health: "uint32[4]" },
      codegen: { dataStruct: false },
    },

    MatchTerrain: {
      key: ["matchEntity"],
      schema: { matchEntity: "Entity", terrain: "bytes" },
      codegen: { dataStruct: false },
    },

    /// Address Components

    InQueue: {
      key: ["playerAddress"],
      schema: { playerAddress: "address", startBlock: "uint32", map: "Entity" },
      codegen: { dataStruct: false },
    },

    Rating: {
      key: ["playerAddress"],
      schema: { playerAddress: "address", mu: "uint256", sigma: "uint256" },
      codegen: { dataStruct: false },
    },

    MatchLookup: {
      key: ["playerAddress"],
      schema: { playerAddress: "address", matchEntity: "Entity", player: "Entity" },
      codegen: { dataStruct: false },
    },

    Tick: {
      key: ["entity"],
      schema: { entity: "Entity", lastBlock: "uint32", count: "uint32" },
      codegen: { dataStruct: false },
    },

    /// GENERAL COMPONENTS

    EntityCounter: {
      key: [],
      schema: { count: "uint32" },
      codegen: { dataStruct: false },
    },

    /// TILEMAP COMPONENTS
    Map: {
      key: ["id"],
      schema: {
        id: "Entity",
        name: "string",
        description: "string",
        spawnIndexes: "uint32[4]",
        terrain: "bytes",
      },
      codegen: {
        dataStruct: false,
      },
    },

    /// SESSION COMPONENTS
    // Session: {
    //   key: ["id"],
    //   schema: {
    //     id: "Entity",
    //     variant: "SessionType",
    //     mapId: "Entity",
    //     roundBlockDelay: "uint32"
    //   },
    //   codegen: { dataStruct: false },
    //

    Session: {
      key: ["id"],
      schema: { id: "Entity", sessionType: "SessionType" },
      codegen: { dataStruct: false },
    },

    SessionMap: {
      key: ["id"],
      schema: { id: "Entity", mapId: "Entity", terrain: "bytes" },
      codegen: { dataStruct: false },
    },

    SessionPlayers: {
      key: ["id"],
      schema: { id: "Entity", players: "bytes32[4]" },
      codegen: { dataStruct: false },
    },

    SessionHealth: {
      key: ["id"],
      schema: {
        id: "Entity",
        health: "uint8[4]",
      },
      codegen: { dataStruct: false },
    },

    TileLookup: {
      key: ["matchEntity", "tileIndex", "entityType"],
      schema: {
        matchEntity: "Entity",
        tileIndex: "uint32",
        entityType: "EntityType",
        entity: "Entity",
      },
      codegen: {
        dataStruct: false,
      },
    },

    /// BOMB COMPONENTS
    BombIndex: {
      key: ["id"],
      schema: { id: "Entity", index: "uint32" },
      codegen: { dataStruct: false },
    },

    BombOwner: {
      key: ["id"],
      schema: { id: "Entity", player: "Entity" },
      codegen: { dataStruct: false },
    },

    BombRange: {
      key: ["id"],
      schema: { id: "Entity", value: "uint32" },
      codegen: { dataStruct: false },
    },

    /// PLAYER COMPONENTS
    Player: {
      key: ["id"],
      schema: { id: "Entity", isPlayer: "bool" },
      codegen: { dataStruct: false },
    },

    Position: {
      key: ["id"],
      schema: { id: "Entity", x: "uint32", y: "uint32" },
      codegen: { dataStruct: false },
    },

    LastBombIndex: {
      key: ["id"],
      schema: { id: "Entity", tileIndex: "uint32" },
      codegen: { dataStruct: false },
    },

    Health: {
      key: ["id"],
      schema: { id: "Entity", count: "uint32" },
      codegen: { dataStruct: false },
    },

    FireCount: {
      key: ["id"],
      schema: { id: "Entity", value: "uint32" },
      codegen: { dataStruct: false },
    },

    BombCount: {
      key: ["id"],
      schema: { id: "Entity", value: "uint32" },
      codegen: { dataStruct: false },
    },

    BombUsed: {
      key: ["id"],
      schema: { id: "Entity", value: "uint32" },
      codegen: { dataStruct: false },
    },
  },
});
