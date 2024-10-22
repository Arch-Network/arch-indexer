# Arch TypeScript SDK

This SDK provides a TypeScript interface for interacting with the Arch RPC server.

## Installation

```bash
npm install arch-typescript-sdk
```

## Usage

```typescript
import { ArchRpcClient } from 'arch-typescript-sdk';

const client = new ArchRpcClient('http://your-rpc-server-url');

async function example() {
  try {
    const isReady = await client.isNodeReady();
    console.log('Is node ready?', isReady);

    const accountAddress = await client.getAccountAddress(new Uint8Array(32)); // Replace with actual pubkey
    console.log('Account address:', accountAddress);

    // ... other method calls ...
  } catch (error) {
    console.error('Error:', error);
  }
}

example();
```

## API

- `isNodeReady(): Promise<boolean>`
- `getAccountAddress(accountPubkey: Uint8Array): Promise<string>`
- `readAccountInfo(pubkey: Pubkey): Promise<AccountInfoResult>`
- `sendTransaction(transaction: RuntimeTransaction): Promise<string>`
- `sendTransactions(transactions: RuntimeTransaction[]): Promise<string[]>`
- `getBlockCount(): Promise<number>`
- `startDkg(): Promise<void>`
- `getBlockHash(height: number): Promise<string>`
- `getBlock(hash: string): Promise<Block>`
- `getProcessedTransaction(txId: string): Promise<ProcessedTransaction>`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
