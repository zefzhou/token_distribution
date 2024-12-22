import hre from "hardhat";
import path from "path";

import Lock from "../ignition/modules/Lock";


async function main() {
    const { lock } = await hre.ignition.deploy(Lock, {
        // This must be an absolute path to your parameters JSON file
        parameters: path.resolve(__dirname, "../ignition/parameters.json"),
    });

    console.log(`Lock deployed to: ${await lock.getAddress()}`);
}

main().catch(console.error);