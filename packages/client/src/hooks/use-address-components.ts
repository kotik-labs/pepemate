import { useComponentValue } from "@latticexyz/react";
import { components } from "@/lib/mud/recs";
import { Entity } from "@latticexyz/recs";

const { InQueue, Rating, MatchLookup } = components;

export const useAddressComponents = (addressEntity: Entity) => {
  const queue = useComponentValue(InQueue, addressEntity);
  const rating = useComponentValue(Rating, addressEntity);
  const lookup = useComponentValue(MatchLookup, addressEntity);

  return {
    queue,
    rating,
    lookup,
  };
};
