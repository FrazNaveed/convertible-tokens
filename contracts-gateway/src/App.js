import { EthereumProvider } from "./hooks/globalStateHandler";
import WalletConnect from "./components/WalletConnect";
import EggFactory from "./components/EggFactory";
import PetFactory from "./components/PetFactory";
import { Typography, Accordion, AccordionSummary, AccordionDetails } from '@material-ui/core';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import 'fontsource-roboto';

function App() {
	return (
		<EthereumProvider>
			<WalletConnect />
			<Accordion>
				<AccordionSummary
					expandIcon={<ExpandMoreIcon />}
					aria-controls="panel1a-content"
					id="panel1a-header"
				>
					<Typography variant="h5" gutterBottom>
						Egg Factory
      				</Typography>
				</AccordionSummary>
				<AccordionDetails>
					<EggFactory />
				</AccordionDetails>
			</Accordion>
			<Accordion>
				<AccordionSummary
					expandIcon={<ExpandMoreIcon />}
					aria-controls="panel2a-content"
					id="panel2a-header"
				>
					<Typography variant="h5" gutterBottom>
						Pet Factory
				  	</Typography>
				</AccordionSummary>
				<AccordionDetails>
					<PetFactory />
				</AccordionDetails>
			</Accordion>
		</EthereumProvider>
	);
}

export default App;