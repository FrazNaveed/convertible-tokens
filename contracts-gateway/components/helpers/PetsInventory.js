import {
    Typography,
    Grid,
    Paper,
    Accordion,
    AccordionSummary,
    AccordionDetails,
    makeStyles
} from '@material-ui/core';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';

const useStyles = makeStyles((theme) => ({
    paper: {
        padding: theme.spacing(2),
        textAlign: 'center',
        color: theme.palette.text.secondary,
    }
}));

let PetsInventory = ({pnames, pvisuals}) => {
    const classes = useStyles();
    var i = 0;

    if (!pnames) {
        return;
    }

    return (
        <Accordion>
            <AccordionSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel2a-content"
                id="panel2a-header"
            >
                <Typography variant="h6" gutterBottom>
                    Available Pets
              </Typography>
            </AccordionSummary>
            <AccordionDetails>
                <Grid container spacing={3} key={i}>
                    {
                        pnames.map((pet) => {
                            let visual = pvisuals[i];
                            i++;
                            return (
                                <Grid item xs={6} key={i}>
                                    <Paper elevation={3} className={classes.paper}>
                                        <Typography variant="h6" gutterBottom>{pet}</Typography>
                                        <Typography variant="button" gutterBottom>IPFS: {visual}</Typography>
                                    </Paper>
                                </Grid>
                            );
                        })
                    }
                </Grid>
            </AccordionDetails>
        </Accordion>
    );
}

export default PetsInventory;