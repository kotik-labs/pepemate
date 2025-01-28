import { Card, CardContent } from "@/components/ui/card";
import { AccountButton } from "@latticexyz/entrykit/internal";

export function NotConnected() {
  return (
    <Card className="w-96 bg-black text-white">
      <CardContent>
        <div className="flex flex-col items-center p-4 mt-4 gap-4">
          <p>Not connected :(</p>
          <AccountButton />
        </div>
      </CardContent>
    </Card>
  );
}
