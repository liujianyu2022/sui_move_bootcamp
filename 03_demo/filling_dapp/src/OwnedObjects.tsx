import { useCurrentAccount, useSuiClientQuery } from "@mysten/dapp-kit";


export function OwnedObjects() {
  const account = useCurrentAccount();
  // const { data, isPending, error } = useSuiClientQuery(
  //   "getOwnedObjects",
  //   {
  //     owner: account?.address as string,
  //   },
  //   {
  //     enabled: !!account,
  //   },
  // );

  return (
    <div>

    </div>
  )
}
