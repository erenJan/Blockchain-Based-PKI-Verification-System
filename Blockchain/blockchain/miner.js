const bodyParser = require('body-parser');
const express = require('express');
const request = require('request');
const path = require('path');
const cors = require('cors');
const Blockchain = require('../blockchain');
const PubSub = require('../app/pubsub');
const TransactionPool = require('../wallet/transaction-pool');
const Wallet = require('../wallet');
const CustomWallet = require('../wallet/customWallet')
const TransactionMiner = require('../app/transaction-miner');




const REDIS_URL =
  'redis://127.0.0.1:6379' 
const blockchain = new Blockchain();
const transactionPool = new TransactionPool();
const wallet = new Wallet();
const pubsub = new PubSub({ blockchain, transactionPool, redisUrl: REDIS_URL });
const transactionMiner = new TransactionMiner({ blockchain, transactionPool, wallet, pubsub });


while (true) {
    transactionMiner.mineTransactions();
    console.log(blockchain.chain.length)
}