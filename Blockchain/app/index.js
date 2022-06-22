const bodyParser = require('body-parser');
const express = require('express');
const request = require('request');
const path = require('path');
const cors = require('cors');
const Blockchain = require('../blockchain');
const PubSub = require('./pubsub');
const TransactionPool = require('../wallet/transaction-pool');
const Wallet = require('../wallet');
const CustomWallet = require('../wallet/customWallet')
const TransactionMiner = require('./transaction-miner');

const { MINING_REWARD } = require('../config');

const isDevelopment = process.env.ENV === 'development';

const REDIS_URL =
  'redis://127.0.0.1:6379' 
const DEFAULT_PORT = 3000;
const ROOT_NODE_ADDRESS = `http://localhost:${DEFAULT_PORT}`;

const app = express();
const blockchain = new Blockchain();
const transactionPool = new TransactionPool();
const wallet = new Wallet();
const pubsub = new PubSub({ blockchain, transactionPool, redisUrl: REDIS_URL });
const transactionMiner = new TransactionMiner({ blockchain, transactionPool, wallet, pubsub });

app.use(bodyParser.json({limit: '50mb'}));
app.use(express.static(path.join(__dirname, 'client/dist')));
app.use(cors());

app.get('/api/create-new-wallet',(req,res) => {
  
  const neWallet = new Wallet()

  res.json({
    private_address: neWallet.keyPair.getPrivate().toString(16),
    public_address: neWallet.publicKey,
  })
})


app.get('/api/lastest-blocks', (req,res) =>{
  let api_chain = []
  for (let index = blockchain.chain.length-1; index > blockchain.chain.length - 10; index--) {
    console.log(blockchain.chain[index])
    api_chain.push(blockchain.chain[index])    
  }
  res.json(api_chain);
})

app.get('/api/informations', (req,res) => {
  let information = []
  information.push(MINING_REWARD)
  information.push()
  res.json(information)
})
 
app.get('/api/blocks', (req, res) => {
  res.json(blockchain.chain);
});

app.get('/api/blocks/length', (req, res) => {
  res.json(blockchain.chain.length);
});

app.get('/api/blocks/:id', (req, res) => {
  const { id } = req.params;
  const { length } = blockchain.chain;

  const blocksReversed = blockchain.chain.slice().reverse();

  let startIndex = (id-1) * 5;
  let endIndex = id * 5;

  startIndex = startIndex < length ? startIndex : length;
  endIndex = endIndex < length ? endIndex : length;

  res.json(blocksReversed.slice(startIndex, endIndex));
});

app.post('/api/mine', (req, res) => {
  const { data } = req.body;

  blockchain.addBlock({ data });

  pubsub.broadcastChain();

  res.redirect('/api/blocks');
});

app.post('/api/wallet-balance',(req,res) => {
    const {address} = req.body;

    res.json({
        balance: Wallet.calculateBalance({
            chain:  blockchain.chain,
            address:    address
        })
    })
})

app.post('/api/transact', (req, res) => {
  const { amount, recipient } = req.body;

  let transaction = transactionPool
    .existingTransaction({ inputAddress: wallet.publicKey });

  try {
    if (transaction) {
      transaction.update({ senderWallet: wallet, recipient, amount });
    } else {
      transaction = wallet.createTransaction({
        recipient,
        amount,
        chain: blockchain.chain
      });
    }
  } catch(error) {
    return res.status(400).json({ type: 'error', message: error.message });
  }

  transactionPool.setTransaction(transaction);

  pubsub.broadcastTransaction(transaction);

  res.json({ type: 'success', transaction });
});


app.post('/api/custom-transact', (req,res) =>{
  const{customWallet,recipient,amount} = req.body;
  console.log(customWallet)
  const a = new Wallet(customWallet,blockchain.chain)
  console.log(a.publicKey)
  let transaction = transactionPool
    .existingTransaction({ inputAddress: a.publicKey });

  try {
    if (transaction) {
      transaction.update({ senderWallet: a, recipient, amount });
    } else {
      transaction = a.createTransaction({
        recipient,
        amount,
        chain: blockchain.chain
      });
    }
  } catch(error) {
    console.log(error)
    return res.status(400).json({ type: 'error', message: error.message });
  }

  transactionPool.setTransaction(transaction);

  pubsub.broadcastTransaction(transaction);

  res.json({ type: 'success', transaction });

})




app.get('/api/transaction-pool-map', (req, res) => {
  res.json(transactionPool.transactionMap);
});

app.get('/api/mine-transactions', (req, res) => {
  transactionMiner.mineTransactions();

  res.redirect('/api/blocks');
});

app.get('/api/wallet-info', (req, res) => {
  const address = wallet.publicKey;

  res.json({
    private_address: wallet.keyPair.getPrivate().toString(16),
    public_address: address,
    balance: Wallet.calculateBalance({ chain: blockchain.chain, address })
  });
});

app.post('/api/search-balance', (req, res) => {
    const {address} = req.body;
    let balance = Wallet.calculateBalance({ chain: blockchain.chain, address })
    balance = balance.toString()
    if(balance.length > 4){
      var zerocount = 0;
    var total = 0;
    for(var i = 0; i<balance.length;i++){
      if(balance[i] == 0){
        console.log(balance[i])
        if(i+1 == balance.length){
          zerocount = zerocount + 1;
          total = total + (10**zerocount)
        }else{
          if(balance[i] == balance[i+1]){
            zerocount = zerocount + 1;
  
          }else{
            total = total + (10**zerocount)
            zerocount = 0
          }
        }
        
      }
    }
    }else{
      var total = balance
    }

    res.json({
      balance: parseInt(total)
    });
  });

app.get('/api/known-addresses', (req, res) => {
  const addressMap = {};

  for (let block of blockchain.chain) {
    for (let transaction of block.data) {
      const recipient = Object.keys(transaction.outputMap);

      recipient.forEach(recipient => addressMap[recipient] = recipient);
    }
  }

  res.json(Object.keys(addressMap));
});

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'client/dist/index.html'));
});

const syncWithRootState = () => {
  request({ url: `${ROOT_NODE_ADDRESS}/api/blocks` }, (error, response, body) => {
    if (!error && response.statusCode === 200) {
      const rootChain = JSON.parse(body);

      console.log('replace chain on a sync with', rootChain);
      blockchain.replaceChain(rootChain);
    }
  });

  request({ url: `${ROOT_NODE_ADDRESS}/api/transaction-pool-map` }, (error, response, body) => {
    if (!error && response.statusCode === 200) {
      const rootTransactionPoolMap = JSON.parse(body);

      console.log('replace transaction pool map on a sync with', rootTransactionPoolMap);
      transactionPool.setMap(rootTransactionPoolMap);
    }
  });
};

if (isDevelopment) {
  const walletFoo = new Wallet();
  const walletBar = new Wallet();

  const generateWalletTransaction = ({ wallet, recipient, amount }) => {
    const transaction = wallet.createTransaction({
      recipient, amount, chain: blockchain.chain
    });

    transactionPool.setTransaction(transaction);
  };

  const walletAction = () => generateWalletTransaction({
    wallet, recipient: walletFoo.publicKey, amount: 5
  });

  const walletFooAction = () => generateWalletTransaction({
    wallet: walletFoo, recipient: walletBar.publicKey, amount: 10
  });

  const walletBarAction = () => generateWalletTransaction({
    wallet: walletBar, recipient: wallet.publicKey, amount: 15
  });

  for (let i=0; i<20; i++) {
    if (i%3 === 0) {
      walletAction();
      walletFooAction();

    } else if (i%3 === 1) {
      walletAction();
      walletBarAction();
    } else {
      walletFooAction();
      walletBarAction();
    }

    transactionMiner.mineTransactions();
  }
}

let PEER_PORT;

if (process.env.GENERATE_PEER_PORT === 'true') {
  PEER_PORT = DEFAULT_PORT + Math.ceil(Math.random() * 1000);
}

const PORT = process.env.PORT || PEER_PORT || DEFAULT_PORT;
app.listen(PORT, () => {
  console.log(`listening at localhost:${PORT}`);

  if (PORT !== DEFAULT_PORT) {
    syncWithRootState();
  }
});
