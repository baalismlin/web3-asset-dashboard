import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("SimpleTokenModule", (m) => {
  const simpleToken = m.contract("SimpleToken");

  m.call(simpleToken, "mint", [1000n]);

  return { simpleToken };
});
