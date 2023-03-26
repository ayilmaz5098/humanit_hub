import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import config from '../config.json';

import Navbar from './Navbar';
import MetaMaskButton from './MetaMaskButton';
import ProposalForm from './ProposalForm';
import HomeButton from './HomeButton';

function App() {
  const dispatch = useDispatch();

  const loadBlockchainData = async () => {
    // TODO: Load blockchain data
    const provider = loadProvider(dispatch)

    // Fetch current network's chainId (e.g. hardhat: 31337, kovan: 42)
    const chainId = await loadNetwork(provider, dispatch)

    // Reload page when network changes
    window.ethereum.on('chainChanged', () => {
      window.location.reload()
    })

    // Fetch current account & balance from Metamask when changed
    window.ethereum.on('accountsChanged', () => {
      loadAccount(provider, dispatch)
    })

    // Load token smart contracts
    const DApp = config[chainId].DApp
    const mETH = config[chainId].mETH
    await loadTokens(provider, [DApp.address, mETH.address], dispatch)


  };

  useEffect(() => {
    loadBlockchainData();
  }, []);

  return (
    <div>
      <Navbar />
      
      <MetaMaskButton />

      <main>
        <ProposalForm />
        <HomeButton />
      </main>

      <Transactions />
    </div>
  );
}

export default App;
