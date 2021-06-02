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

let PetFactory = () => {
    const { state } = useContext(EthereumContext);
    const [dataFetched, setDataFetched] = useState(false);
    const [selectedEgg, setSelectedEgg] = useState("");
    const [userEggs, setUserEggs] = useState([[]]);
    const [petFee, setPetFee] = useState(-1);
    const classes = useStyles();

    if (state.contracts.eggToken && !dataFetched) {
        setDataFetched(true);
        state.contracts.eggToken.methods.getUserEggs(state.web3.givenProvider.selectedAddress).call().then(async (data) => {
            var userEggColors = [];
            for (var i = 0; i < data.length; i++) {
                var eggData = await state.contracts.eggToken.methods.getEggFromMintedId(data[i]).call();
                if (eggData.color == "BURNT") { continue; }
                userEggColors.push([data[i], eggData.color]);
            }
            setUserEggs(userEggColors);
        });
        state.contracts.petFactory.methods.getPetFees().call().then((data) => {
            setPetFee(data);
        });
    }

    let handleChange = (event) => {
        setSelectedEgg(event.target.value);
    }

    let hatchEgg = () => {
        if (selectedEgg.length == 0) {
            alert("Please select an egg from dropdown!");
            return;
        }
        var petsBefore = -1;
        state.contracts.petToken.methods.getUserPets(state.web3.givenProvider.selectedAddress).call().then((pets) => {
            petsBefore = pets.length;
        });
        state.contracts.candyToken.methods.approve(state.contracts.petFactory._address, petFee).send({ from: state.web3.givenProvider.selectedAddress }).then(() => {
            state.contracts.petFactory.methods.buyPet(selectedEgg[0]).send({ from: state.web3.givenProvider.selectedAddress }).then(() => {
                state.contracts.petToken.methods.getUserPets(state.web3.givenProvider.selectedAddress).call().then((pets) => {
                    if (pets.length > petsBefore) {
                        var mintedId = pets[pets.length - 1];
                        console.log("Pet minted", mintedId);
                        state.contracts.petToken.methods.getMintedPet(mintedId).call().then((newPet) => {
                            alert("Congratulations! You just hatched a " + newPet.petName + "\nIPFS Visual: " + newPet.petVisual);
                        });
                    } else {
                        alert("Sorry, something went wrong while minting the pet.");
                    }
                });
            });
        });
    }

    let displayHelpers = petFee > 0 ? "block" : "none";
    let i = 0;

    return (
        <div className={classes.root} align="center" justify="center">
            <FormControl className={classes.formInput}>
                <InputLabel id="demo-simple-select-helper-label2">Your current eggs</InputLabel>
                <Select
                    labelId="demo-simple-select-helper-label2"
                    id="demo-simple-select-helper2"
                    value={selectedEgg}
                    onChange={handleChange}
                >
                    {
                        userEggs.map((egg) => {
                            return <MenuItem value={egg[0]} key={i++}>{egg[1]}</MenuItem>
                        })
                    }
                </Select>
                <FormHelperText style={{ display: `${displayHelpers}` }}>
                    Current egg hatching fee is <strong>{petFee} candies</strong>
                </FormHelperText>
            </FormControl>
            <Button variant="contained" color="primary" className={classes.formButton} onClick={() => { hatchEgg() }}>
                Hatch it!
            </Button>
        </div>
    );
}

export default PetFactory;