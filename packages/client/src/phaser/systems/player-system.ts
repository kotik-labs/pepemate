import {
  defineSystem,
  Entity,
  getComponentValue,
  Has,
  HasValue,
  UpdateType,
} from "@latticexyz/recs";
import { PhaserLayer } from "../create-phaser-layer";
import { Sprites, Direction } from "@/types";
import { ANIMATION_INTERVAL, PlayerAnimationsLookup } from "@/constants";
import { singletonEntity } from "@latticexyz/store-sync/recs";
import { Coord } from "@latticexyz/phaserx";
import { drawPlayer } from "@/lib/game/drawing";

const PlayerSprites = [
  Sprites.PlayerA,
  Sprites.PlayerB,
  Sprites.PlayerC,
  Sprites.PlayerD,
] as const;

const directions = (p0: Coord, p1: Coord) => {
  const deltaX = p0.x - p1.x;
  const deltaY = p0.y - p1.y;

  return [
    deltaX > 0 ? Direction.Right : deltaX < 0 ? Direction.Left : null,
    deltaY > 0 ? Direction.Down : deltaY < 0 ? Direction.Up : null,
  ];
};

export function createPlayerSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: { objectPool, phaserScene, config },
    },
    network: {
      world,
      components: { Player, Position, LocalSession, EntityMatch, MatchPlayers },
    },
  } = layer;

  defineSystem(
    world,
    [HasValue(Player, { isPlayer: true }), Has(EntityMatch), Has(Position)],
    ({ entity, value, component, type }) => {
      const localSession = getComponentValue(LocalSession, singletonEntity);
      if (!localSession) return;

      const session = getComponentValue(EntityMatch, entity);
      if (!session || session.session !== localSession.id) return;

      if (type === UpdateType.Exit) {
        console.log("DEAD", { entity, value, type });
        objectPool.remove(entity);
        return;
      }

      const { players }: { players: string[] } = getComponentValue(
        MatchPlayers,
        session.session as Entity
      ) || { players: [] };

      const playerIndex = players.indexOf(entity);
      if (playerIndex === -1) return;

      const playerSprite = PlayerSprites[playerIndex];
      const texture = config.sprites[playerSprite];
      const moveAnimations = PlayerAnimationsLookup[playerSprite];

      if (type === UpdateType.Enter) {
        /// add player on map if alive
        const position = getComponentValue(Position, entity);
        if (!position || (position.x === 0 && position.y === 0)) return;
        drawPlayer(objectPool, entity, position, texture);
      }

      if (type == UpdateType.Update && component.id === Position.id) {
        // update position
        const coord = value[0] as Coord;
        const prevCoord = value[1] as Coord;
        console.log(coord);

        const spawned = prevCoord.x === 0 && prevCoord.y === 0;
        if (spawned) {
          // console.log("SPAWN", { entity, value, type });
          drawPlayer(objectPool, entity, coord, texture);
          return;
        }

        // console.log("MOVE", { entity, value, type });
        const [dirX, dirY] = directions(coord, prevCoord);

        objectPool.get(entity, "Sprite").setComponent({
          id: entity,
          once: (gameObject) => {
            // gameObject.setPosition(coord.x, coord.y);
            gameObject.setOrigin(0.5, 16 / 24);
            gameObject.setScale(1);
            const direction = dirX || dirY;

            if (direction !== null) {
              gameObject.play(moveAnimations[direction], true);
              phaserScene.tweens.add({
                targets: gameObject,
                x: { start: prevCoord.x, to: coord.x },
                y: { start: prevCoord.y, to: coord.y },
                ease: "Linear",
                duration: ANIMATION_INTERVAL,
                repeat: 0,
              });
              return;
            }

            const animation = gameObject.anims.currentAnim;
            if (animation) gameObject.stopOnFrame(animation.frames[0]);
          },
        });
      }
    }
  );
}
