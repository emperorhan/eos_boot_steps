#!/bin/bash    
killall nodeos

#unlock wallet
./00_WALLET_IMPORT.sh &> /dev/null

#run eosio node. see datadir for logs
./../eosio_node/start.sh

nodeos -e -p eosio --plugin eosio::producer_plugin --max-transaction-time=300 --plugin eosio::chain_api_plugin --plugin eosio::net_api_plugin --signature-provider=EOS5kiTBoD38FxXTmcPzJS3EjtcusKE2WkEfjGEPFTnnth21hQMHa=KEY:5KX9iLDRus4jevcBRPArmPRrkQFD9MBtTEdjAxnYMR5a9wcs46W --genesis-json /home/eos/ibctprivate/genesis.json --delete-all-blocks > /home/eos/ibctprivate/stdout.txt 2> /home/eos/ibctprivate/stderr.txt & echo $! > /home/eos/ibctprivate/nodoes.pid

#give time for the node to be initialized.
sleep 2s

#run booting sequences. sleep 1s between each sript for actions to get propagated
./02* 
./03*
./04*
#set contract setpriv might take too long so that it sometimes gets reject.
#there fore run in three times to make sure that the contract is set properly
#changes: in order to prevent transactions taking more than 30ms and being refused, eosio::producer_plugin --max-transaction-time=300 parameter has been added to eosio node
./05*

./06*
sleep 2s
./07*
sleep 2s

./cleos.sh get info
#now manually shutdown eosio nodeos
