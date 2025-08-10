import { CdpClient } from "@coinbase/cdp-sdk";
import "dotenv/config";

const cdp = new CdpClient();


// Get an existing account
const account = await cdp.evm.getOrCreateAccount({
  name: "paymaster"
});
console.log(`Original account name: ${account.name}`);

console.log(account.address);
