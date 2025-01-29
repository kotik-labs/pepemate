import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "pepemate",
  deploy: {
    upgradeableWorldImplementation: true,
  },
  userTypes: {
    Entity: { type: "bytes32", filePath: "./src/Entity.sol" },
  },
  enums: {
    SessionStatus: ["InLobby", "Playing"],
    TileType: [
      "None",
      "Grass",
      "Block",
      "Wall",
      "RangeUp",
      "SpeedUp",
      "BombsUp",
      "SpawnA",
      "SpawnB",
      "SpawnC",
      "SpawnD",
    ],
    EntityType: ["Player", "Bomb"],
    Direction: ["Up", "Left", "Right", "Down"],
  },
  tables: {
    /// GENERAL COMPONENTS
    Tick: {
      key: ["id"],
      schema: { id: "Entity", lastBlock: "uint32", count: "uint32" },
      codegen: { dataStruct: false },
    },

    /// TILEMAP COMPONENTS
    Map: {
      key: ["id"],
      schema: {
        id: "bytes32",
        spawnIndexes: "uint32[4]",
        tileMap: "bytes",
      },
      codegen: {
        dataStruct: false,
      },
    },

    /// SESSION COMPONENTS
    SessionState: {
      key: ["id"],
      schema: {
        id: "Entity",
        // mapId: "Entity",
        status: "SessionStatus",
        playerBitmap: "uint8",
        spawnIndexes: "uint32[4]",
        map: "bytes",
      },
    },

    TileLookup: {
      key: ["session", "tileIndex", "entityType"],
      schema: {
        session: "Entity",
        tileIndex: "uint32",
        entityType: "EntityType",
        entity: "Entity",
      },
      codegen: {
        dataStruct: false,
      },
    },

    Session: {
      key: ["id"],
      schema: { id: "Entity", session: "Entity" },
      codegen: { dataStruct: false },
    },

    PlayerIndex: {
      key: ["id"],
      schema: { id: "Entity", playerIndex: "uint8" },
      codegen: { dataStruct: false },
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
