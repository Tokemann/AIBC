const path = require('path');
const fs = require('fs');
const solc = require('solc');
// Compile contract
const contractPath = path.resolve(__dirname, 'contracts', 'CustomERC20.sol');
const abiPath = path.resolve(__dirname, 'build', 'abi', 'CustomERC20.abi');
//console.log(contractPath);
const source = fs.readFileSync(contractPath, 'utf8');
const input = {
   language: 'Solidity',
   sources: {
      'CustomERC20.sol': {
         content: source,
      },
   },
   settings: {
      outputSelection: {
         '*': {
            '*': ['*'],
         },
      },
   },
};
const tempFile = JSON.parse(solc.compile(JSON.stringify(input)));
console.log(typeof tempFile);
const contractFile = tempFile.contracts['CustomERC20.sol']['CustomERC20'];
fs.writeFileSync(abiPath,JSON.stringify(contractFile));
module.exports = contractFile;