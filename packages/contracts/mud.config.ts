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
    GameMode: ["Trainning", "Arena", "Hardcore"],
    TeamMode: ["AllInOne", "TeamFight"],
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

    Session: {
      key: ["id"],
      schema: {
        id: "bytes32",
        status: "SessionStatus",
        gameMode: "GameMode",
        teamMode: "TeamMode",
        playerBitmap: "uint8",
        spawnIndexes: "uint32[4]",
        map: "bytes",
      },
    },

    SessionOf: "bytes32",
    PlayerIndex: "uint8",

    Position: {
      key: ["id"],
      schema: {
        id: "bytes32",
        x: "uint32",
        y: "uint32",
      },
      codegen: {
        dataStruct: false,
      },
    },

    LastBombPlaced: {
      key: ["id"],
      schema: {
        id: "bytes32",
        tileX: "uint32",
        tileY: "uint32",
      },
      codegen: {
        dataStruct: false,
      },
    },

    TileLookup: {
      key: ["session", "tileX", "tileY", "entityType"],
      schema: {
        session: "bytes32",
        tileX: "uint32",
        tileY: "uint32",
        entityType: "EntityType",
        id: "bytes32",
      },
      codegen: {
        dataStruct: false,
      },
    },

    Bomb: "bool",
    DetonateAt: "uint32",
    BombRange: "uint32",
    PlacedBy: "bytes32",

    Player: "bool",
    FireCount: "uint32",
    BombCount: "uint32",
    BombUsed: "uint32",

    LastBlock: "uint32",
    TickCount: "uint32",
  },
});
