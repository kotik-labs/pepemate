import { Card, CardContent } from "@/components/ui/card";
import { shorten } from "@/lib/utils";
import { MOCK_SESSION } from "@/constants";
import { Link } from "react-router";

import { Hex } from "viem";

export type SessionListProps = {
  sessions: Hex[];
};

export const SessionList = ({ sessions }: SessionListProps) => {
  return (
    <div className="flex flex-col justify-start gap-2">
      {sessions.map((session, i) => (
        <SessionItem key={i} session={session} />
      ))}
    </div>
  );
};

export type SessionItemProps = {
  session: Hex;
};

export const SessionItem = ({ session }: SessionItemProps) => {
  const sessionLink = `/${session}`;

  return (
    <Link
      className="ring-2 px-2 rounded-md ring-slate-700 hover:ring-slate-50"
      to={sessionLink}
    >
      {shorten(session)}
    </Link>
  );
};

export function Sessions() {
  return (
    <Card className="w-[450px] bg-black text-white">
      <CardContent>
        <div>
          <p className="my-2">Rooms</p>
          <SessionList sessions={[MOCK_SESSION, MOCK_SESSION]} />
        </div>
      </CardContent>
    </Card>
  );
}
