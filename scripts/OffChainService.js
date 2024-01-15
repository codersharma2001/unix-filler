const axios = require('axios');
const { createAlchemyWeb3 } = require('@alch/alchemy-web3');
const ABI = require('./OracleABI.json')

// Connect to your Ethereum node
const web3 = createAlchemyWeb3('https://eth-sepolia.g.alchemy.com/v2/xnNWnpBMlZABF_rBFjTf2aKBL-N3RkJN');

// Address of YourOracle contract
const oracleAddress = '0xd9c0ffe0A366Bb665319551dBD47530208e0B179';

// Your Ethereum private key for signing transactions
const privateKey = 'f679336601f4713be7c039641a8f6fad0364cd1264a710f49f6bf3173fae04e4';

// Function to fetch data from Uniswap API
async function fetchUniswapOrder() {
    try {
        const response = await axios.get('https://api.uniswap.org/v2/orders?orderStatus=open&chainId=1&limit=1');
        const data = response.data;
        return data;
    } catch (error) {
        console.error('Error fetching data from Uniswap API:', error.message);
        throw error;
    }
}

// Function to interact with YourOracle contract and provide data
async function provideDataToOracle(data) {
    const oracleContract = new web3.eth.Contract(ABI, oracleAddress);
    const requestId = await oracleContract.methods.requestData().send({ from: '0x74d84624A5eAA350c678E8C578A859b7EeE55ab1', gas: '300000' });

    await oracleContract.methods.provideData(requestId, data).send({
        from: '0x74d84624A5eAA350c678E8C578A859b7EeE55ab1',
        gas: '300000',
        gasPrice: '10000000000', 
    });

    console.log('Data provided to Oracle with Request ID:', requestId);
}

// Main execution
async function main() {
    const uniswapOrderData = await fetchUniswapOrder();
    await provideDataToOracle(uniswapOrderData);
}

main();
