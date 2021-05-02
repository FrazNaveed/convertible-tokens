import React, { useState, useContext } from "react";
import { EthereumContext } from "../hooks/globalStateHandler";
import Web3 from "web3";
import { Typography, Button } from '@material-ui/core';

let WalletConnect = () => {
    const { state, setProvider, setEthAccount, setContracts } = useContext(EthereumContext);
    const [logged, setLogged] = useState("none");

    let connectMetamask = async () => {
        if (window.ethereum) {
            await window.ethereum.enable();
            setProvider(new Web3(window.ethereum));
            setLogged("block");
            const contracts = require("../contracts_metadata.json");
            setContracts({
                eggFactory: new state.web3.eth.Contract(contracts.EggFactory.ABI, contracts.EggFactory.Address),
                eggToken: new state.web3.eth.Contract(contracts.EggToken.ABI, contracts.EggToken.Address),
                petFactory: new state.web3.eth.Contract(contracts.PetFactory.ABI, contracts.PetFactory.Address),
                petToken: new state.web3.eth.Contract(contracts.PetToken.ABI, contracts.PetToken.Address),
                candyToken: new state.web3.eth.Contract(contracts.CandyToken.ABI, contracts.CandyToken.Address)
            })
            setEthAccount(state.web3.givenProvider.selectedAddress);
        } else {
            alert("MetaMask not found!");
        }
    }

    return (
        <center>
            <Typography style={{ display: `${logged}` }} variant="button" display="block" gutterBottom>Connected Account: {state.ethAccount}</Typography>
            <Button color="primary" onClick={() => connectMetamask()}>Connect with Metamask</Button>
        </center>
    );
}

export default WalletConnect;