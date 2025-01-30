import { cn, rngChoice } from "@/lib/utils";

import cloud1 from "../../public/clouds/cloud-1.png";
import cloud2 from "../../public/clouds/cloud-2.png";
import cloud3 from "../../public/clouds/cloud-3.png";
import cloud4 from "../../public/clouds/cloud-4.png";
import cloud6 from "../../public/clouds/cloud-6.png";
import cloud7 from "../../public/clouds/cloud-7.png";
import cloud8 from "../../public/clouds/cloud-8.png";
import cloud9 from "../../public/clouds/cloud-9.png";
import cloud10 from "../../public/clouds/cloud-10.png";
import cloud11 from "../../public/clouds/cloud-11.png";
import cloud12 from "../../public/clouds/cloud-12.png";
import cloud13 from "../../public/clouds/cloud-13.png";
import cloud14 from "../../public/clouds/cloud-14.png";


export const Clouds = (props: { maxClouds?: number }) => {
  const smallClouds = [
    cloud6,
    cloud7,
    cloud8,
    cloud9,
    cloud10,
    cloud11,
    cloud12,
    cloud13,
    cloud14,
  ];
  const largeClouds = [cloud1, cloud2, cloud3, cloud4];

  const animations = [
    // `animate-[wind_22s_linear_infinite]`,
    `animate-[wind_24s_linear_infinite]`,
    `animate-[wind_25s_linear_infinite]`,
    `animate-[wind_26s_linear_infinite]`,
    `animate-[wind_27s_linear_infinite]`,
    `animate-[wind_28s_linear_infinite]`,
    `animate-[wind_29s_linear_infinite]`,
    `animate-[wind_30s_linear_infinite]`,
    `animate-[wind_31s_linear_infinite]`,
    `animate-[wind_32s_linear_infinite]`,
    // `animate-[wind_32s_linear_infinite]`,
  ];

  const margins = [`ml-16`, `ml-24`, `ml-48`, `ml-56`, `ml-64`];

  return (
    <div className={cn("bottom-0 top-0 right-0 left-0 fixed")}>
      {new Array(props.maxClouds || 16).fill(0).map((_, i) => {
        const animation = rngChoice(animations);
        const margin = rngChoice(margins);
        const image =
          Math.random() > 0.2 ? rngChoice(largeClouds) : rngChoice(smallClouds);

        return (
          <div key={i} className={animation}>
            <img
              src={image}
              alt="img"
              className={cn(`max-w-[400px] scale-100`, margin)}
            />
          </div>
        );
      })}
    </div>
  );
};
