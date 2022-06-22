const Transaction = require('./transaction');
const { STARTING_BALANCE } = require('../config');
const { ec, cryptoHash } = require('../util');

class CustomWallet {
  constructor(wallet,chain){
    

    this.keyPair = ec.keyFromPrivate(wallet);
    console.log(this.keyPair)
    this.balance = CustomWallet.calculateBalance({
      chain,
      address: this.publicKey
    });

    this.publicKey = this.keyPair.getPublic().encode('hex');
    console.log(this.balance)
    console.log(this.publicKey)

  }
  sign(data) {
    return this.keyPair.sign(cryptoHash(data))
  }

  createTransaction({ recipient, amount, chain }) {
    if (chain) {
      this.balance = CustomWallet.calculateBalance({
        chain,
        address: this.publicKey
      });
    }

    if (amount > this.balance) {
      throw new Error('Amount exceeds balance');
    }

    return new Transaction({ senderWallet: this, recipient, amount });
  }

  static calculateBalance({ chain, address }) {
    let hasConductedTransaction = false;
    let outputsTotal = 0;

    for (let i=chain.length-1; i>0; i--) {
      const block = chain[i];

      for (let transaction of block.data) {
        if (transaction.input.address === address) {
          hasConductedTransaction = true;
        }

        const addressOutput = transaction.outputMap[address];

        if (addressOutput) {
          outputsTotal = outputsTotal + addressOutput;
        }
      }

      if (hasConductedTransaction) {
        break;
      }
    }

    return hasConductedTransaction ? outputsTotal : STARTING_BALANCE + outputsTotal;
  }
}

module.exports = CustomWallet;