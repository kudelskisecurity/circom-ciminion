require('hardhat-circom');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.6.7",
  circom: {
    inputBasePath: "./circuits",
    ptau: "pot15_final.ptau",
    circuits: [
       {
        name: "rolling",
        // Generate PLONK
        protocol: 'plonk'
      },
      {
        name: "permutation",
        // Generate PLONK
        protocol: 'plonk'
      },
      {
        name: "key_schedule",
        // Generate PLONK
        protocol: 'plonk'
     },
     {
        name: "ciminion_enc",
        // Generate PLONK
        protocol: 'plonk'
     },
     {
        name: "ciminion_mac",
        // Generate PLONK
        protocol: 'plonk'
     }
    ],
  },
};
