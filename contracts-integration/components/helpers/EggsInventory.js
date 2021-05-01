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

let EggsInventory = ({ecolors, evisuals, eclasses}) => {
    const classes = useStyles();
    var i = 0;

    if (!ecolors) {
        return;
    }

    return (
        <Accordion>
            <AccordionSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
            >
                <Typography variant="h6" gutterBottom>
                    Eggs in inventory
              </Typography>
            </AccordionSummary>
            <AccordionDetails>
                <Grid container spacing={3} key={i}>
                    {
                        ecolors.map((color) => {
                            let visual = evisuals[i];
                            let eclass = eclasses[i];
                            i++;
                            return (
                                <Grid item xs={3} key={i}>
                                    <Paper elevation={3} className={classes.paper}>
                                        <Typography variant="h6" gutterBottom>{color}</Typography>
                                        <Typography variant="button" gutterBottom>IPFS: {visual}</Typography><br />
                                        <Typography variant="caption" gutterBottom>Class: {eclass}</Typography>
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

export default EggsInventory;