var crypto = require('crypto');

var cb_access_timestamp = "1638797226"
var cb_access_passphrase = process.env.PASSPHRASE
var secret = process.env.API_SECRET
var requestPath = "/accounts";
var body = JSON.stringify({
  type: "send",
  to: "0x89811603161fCFaF010f1b9442ac470a81e54D8A",
  amount: "0.7",
  currency: "BAT",
  idem: "9316dd16-0c05",
  description: "Exchange points for crypto"
});
var method = 'POST';

// create the prehash string by concatenating required parts
var message = cb_access_timestamp + "GET" + requestPath + "";
console.log({message})
// decode the base64 secret
var key = Buffer(secret, 'base64');
console.log({key})

// create a sha256 hmac with the secret
var hmac = crypto.createHmac('sha256', key);

// sign the require message with the hmac
// and finally base64 encode the result
var cb_access_sign = hmac.update(message).digest('base64');
console.log({cb_access_sign})

// const crypto = require("crypto")
// var timestamp = "1638785461"
// const body = `{
//   "type": "send",
//   "to": "kevin.mathew@email.com",
//   "amount": "0.0",
//   "currency": "AAVE",
//   "idem": "9316dd16-0c05",
//   "description": "Exchange points for crypto"
// }
//       `
// var message = timestamp + "POST" + '/v2/' + "user" + body;
// var signature = crypto.createHmac('sha256', "0Ud4vPtrkOzAOC8ySDh0N1lc0q370cz9").update(message).digest('hex');
// console.log({signature})
// var Client = require('coinbase').Client;

// var client = new Client({'apiKey': process.env.API_KEY, 
//                          'apiSecret': process.env.API_SECRET});

//                          client.getCurrentUser(function(err, user) {
//                           console.log({user});
//                         });

//                         client.getCurrencies(function(err, currencies) {
//                           console.log({currencies});
//                         });

// client.getAccount('61ad8d40fc87f01ce3bb19e1', function(err, account) {
// account.sendMoney({'to': 'kevinam99@gmail.com',
//                     'amount': '0.1',
//                     'currency': 'BTC',
//                     'idem': '9316dd16-0c05'}, function(err, tx) {
//   console.log(tx);
// });
// });

// https://www.coinbase.com/api_keys/ /show_key
// curl 'https://api.coinbase.com/v2/user' \
// --header 'CB-ACCESS-KEY: eWjoEUbuE3w1rhcv' \
// --header 'CB-ACCESS-SIGN: somth' \
// --header 'CB-ACCESS-TIMESTAMP: 1638763278'

// https://www.coinbase.com/api_keys/61ad8d40fc87f01ce3bb19e1/show_key