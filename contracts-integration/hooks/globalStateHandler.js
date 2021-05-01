import React, { createContext, useReducer } from "react";

export const NetworkReducer = (state, action) => {
    switch (action.type) {
        case "SET_PROVIDER":
            return {...state, web3: action.payload};
        case "SET_ETH_ACCOUNT":
            return {...state, ethAccount: action.payload};
        case "SET_CONTRACTS":
            return {...state, contracts: action.payload};
        default:
            return state;
    }

}

const initialState = {
    web3: null,
    ethAccount: null,
    contracts: {
        eggFactory: null,
        eggToken: null,
        petFactory: null,
        petToken: null,
        candyToken: null
    }
}

export const EthereumContext = createContext(initialState);

export const EthereumProvider = ({ children }) => {
    const [state, dispatch] = useReducer(NetworkReducer, initialState);

    let setProvider = (_payload) => {
        dispatch({
            type: "SET_PROVIDER",
            payload: _payload
        });
    }

    let setEthAccount = (_payload) => {
        dispatch({
            type: "SET_ETH_ACCOUNT",
            payload: _payload
        });
    }

    let setContracts = (_payload) => {
        dispatch({
            type: "SET_CONTRACTS",
            payload: _payload
        });
    }

    return (
        <EthereumContext.Provider
            value={{
                state,
                setProvider,
                setEthAccount,
                setContracts
            }}>
            {children}
        </EthereumContext.Provider>
    );
}