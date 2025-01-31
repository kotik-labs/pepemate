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
    SessionType: ["None", "Public", "Ranked"],
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
        id: "Entity",
        spawnIndexes: "uint32[4]",
        terrain: "bytes",
      },
      codegen: {
        dataStruct: false,
      },
    },

    /// SESSION COMPONENTS
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

    EntitySession: {
      key: ["id"],
      schema: { id: "Entity", session: "Entity" },
      codegen: { dataStruct: false },
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
