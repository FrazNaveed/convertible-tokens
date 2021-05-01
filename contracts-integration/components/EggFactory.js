import React, { useContext, useState } from "react";
import { EthereumContext } from "../hooks/globalStateHandler";
import {
    makeStyles,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    FormHelperText,
    Button
} from '@material-ui/core';
import EggsInventory from "./helpers/EggsInventory";

const useStyles = makeStyles((theme) => ({
    root: {
        flexGrow: 1,
    },
    paper: {
        padding: theme.spacing(2),
        textAlign: 'center',
        color: theme.palette.text.secondary,
    },
    formInput: {
        marginBottom: theme.spacing(5),
        marginRight: theme.spacing(5),
        minWidth: 200
    },
    formButton: {
        marginTop: theme.spacing(2)
    }
}));

let EggFactory = () => {
    const { state } = useContext(EthereumContext);
    const [eggFetched, setEggFetched] = useState(false);
    const [lootboxFetched, setLootboxFetched] = useState(false);
    const [eggColors, setEggColors] = useState([]);
    const [eggVisuals, setEggVisuals] = useState([]);
    const [eggClasses, setEggClasses] = useState([]);
    const [lootboxPrices, setLootboxPrices] = useState([]);
    const [lootboxProbablities, setLootboxProbabilities] = useState([[]]);
    const [selectedLootbox, setSelectedLootbox] = useState(0);
    const [selectedPrice, setSelectedPrice] = useState(0);
    const classes = useStyles();

    if (state.contracts.eggToken && !eggFetched) {
        setEggFetched(true);
        state.contracts.eggToken.methods.getEggRewards().call().then((data) => {
            setEggColors(data.colors);
            setEggVisuals(data.visuals);
            setEggClasses(data.classes);
        });
    }

    if (state.contracts.eggFactory && !lootboxFetched) {
        setLootboxFetched(true);
        state.contracts.eggFactory.methods.getLootboxPrices().call().then((data) => {
            setLootboxPrices(data);
        });
        state.contracts.eggFactory.methods.getLootboxProbabilities().call().then((data) => {
            setLootboxProbabilities(data);
        });
    }

    let handleChange = (ev) => {
        setSelectedLootbox(ev.target.value);
        setSelectedPrice(lootboxPrices[ev.target.value]);
    }

    let buyLootbox = () => {
        if (selectedLootbox < 0) {
            alert("Please select a valid lootbox to open!");
            return;
        }

        state.contracts.candyToken.methods.balanceOf(state.web3.givenProvider.selectedAddress).call().then((bal) => {
            bal = parseInt(bal);
            if (bal < selectedPrice) {
                alert("You do not have sufficient candies of " + selectedPrice + " to open this lootbox!");
                return;
            }
            var previousBalance = [];
            state.contracts.eggToken.methods.getUserEggs(state.web3.givenProvider.selectedAddress).call().then((eggs) => {
                previousBalance = eggs.length;
            });
            state.contracts.candyToken.methods.approve(state.contracts.eggFactory._address, selectedPrice).send({ from: state.web3.givenProvider.selectedAddress }).then(async () => {
                await state.contracts.eggFactory.methods.buyLootbox(selectedLootbox).send({ from: state.web3.givenProvider.selectedAddress });
                state.contracts.eggToken.methods.getUserEggs(state.web3.givenProvider.selectedAddress).call().then((eggs) => {
                    if (eggs.length > previousBalance) {
                        var mintedId = eggs[eggs.length - 1];
                        state.contracts.eggToken.methods.getEggFromMintedId(mintedId).call().then((egg) => {
                            alert("Congratulations! You just minted Egg#" + mintedId + "\nColor: " + egg.color + " - Visual: " + egg.visual + " - Class: " + egg.class);
                        })
                    } else {
                        alert("Unfortunately, something went wrong while minting random egg.");
                    }
                });
            });
        });
    }

    let i = 0;
    let displayHelpers = selectedPrice > 0 ? "block" : "none";

    return (
        <div className={classes.root} align="center" justify="center">
            <FormControl className={classes.formInput}>
                <InputLabel id="demo-simple-select-helper-label">Purchase a lootbox</InputLabel>
                <Select
                    labelId="demo-simple-select-helper-label"
                    id="demo-simple-select-helper"
                    value={selectedLootbox}
                    onChange={handleChange}
                >
                    {
                        lootboxPrices.map(() => {
                            return <MenuItem value={i} key={i}>Lootbox#{++i}</MenuItem>
                        })
                    }
                </Select>
                <FormHelperText style={{ display: `${displayHelpers}` }}>
                    This lootbox will cost you <strong>{selectedPrice} candies</strong>
                </FormHelperText>
                <FormHelperText style={{ display: `${displayHelpers}` }}>
                    It has these egg class probablities: <strong> {
                        lootboxProbablities[(selectedLootbox >= 0 ? selectedLootbox : 0)].map((prob) => {
                            return <span key={i--}>{prob}% </span>
                        })
                    } </strong>
                </FormHelperText>
            </FormControl>
            <Button variant="contained" color="primary" className={classes.formButton} onClick={() => { buyLootbox() }}>
                Try my luck!
            </Button>

            <EggsInventory ecolors={eggColors} evisuals={eggVisuals} eclasses={eggClasses} />
        </div>
    );
}

export default EggFactory;