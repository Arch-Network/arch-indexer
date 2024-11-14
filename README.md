# Arch Network Block Explorer Indexer

A Node.js service that indexes the Arch Network blockchain, storing block and transaction data in PostgreSQL for efficient querying. The indexer processes blocks in parallel batches and provides REST API endpoints for accessing blockchain data.

## Features

- Parallel block processing with configurable batch sizes
- PostgreSQL database with optimized schema and indexes
- REST API endpoints for blocks, transactions, and network statistics
- Real-time sync status monitoring
- Connection pooling and prepared statements for optimal performance
- Docker support for local development
- Cloud Run deployment ready

## API Endpoints

- `GET /api/blocks` - Latest 200 blocks
- `GET /api/blocks/:blockhash` - Block by hash
- `GET /api/blocks/height/:height` - Block by height
- `GET /api/transactions` - Latest 20 transactions
- `GET /api/transactions/:txid` - Transaction by ID
- `GET /api/network-stats` - Network statistics
- `GET /api/sync-status` - Indexer sync status
- `GET /api/search` - Search by block hash, height, or transaction ID

## Local Development Setup

1. Clone the repository:

```
bash
git clone https://github.com/your-org/arch-indexer.git
cd arch-indexer
```

2. Create `.env` file:

```
DB_USER=postgres
DB_PASSWORD=yourpassword
DB_NAME=archindexer
DB_PORT=5432
DB_HOST=localhost
INDEXER_PORT=3003
ARCH_NODE_URL=http://your-arch-node:9002
NODE_ENV=development
```

3. Run with Docker Compose:

```
bash
docker-compose up --build
```

## Cloud Run Deployment

1. Install Google Cloud SDK and configure project:

```
bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

2. Enable required services:

```
gcloud services enable cloudbuild.googleapis.com run.googleapis.com sqladmin.googleapis.com
```

3. Create Cloud SQL instance:

```
export INSTANCE_NAME="arch-indexer-db"
export REGION="us-central1"
gcloud sql instances create $INSTANCE_NAME \
--database-version=POSTGRES_13 \
--tier=db-f1-micro \
--region=$REGION \
--storage-type=SSD \
--storage-size=10GB \
--database-flags=max_connections=100
gcloud sql databases create archindexer --instance=$INSTANCE_NAME
gcloud sql users set-password postgres \
--instance=$INSTANCE_NAME \
--password="your-secure-password"
```

4. Create `env.yaml` from example:

```
cp env.yaml.example env.yaml
```

5. Update `env.yaml` with your values (see env.yaml.example for structure)

6. Deploy to Cloud Run:

```
gcloud run deploy arch-indexer \
--source . \
--platform managed \
--region=us-central1 \
--env-vars-file=env.yaml \
--add-cloudsql-instances=your-project:us-central1:arch-indexer-db \
--memory=2Gi \
--cpu=2 \
--min-instances=1 \
--max-instances=10
```

7. Allow public access (optional):

```
gcloud run services add-iam-policy-binding arch-indexer \
--member="allUsers" \
--role="roles/run.invoker" \
--region=us-central1
```

## Monitoring

View logs:

```
gcloud run services logs read arch-indexer --region=us-central1
```

Check service status:

```
gcloud run services describe arch-indexer --region=us-central1
```

## Performance Tuning

The indexer uses several optimizations that can be configured in `src/index.js`:

- `BATCH_SIZE`: Number of blocks per batch (default: 50)
- `CONCURRENT_BATCHES`: Number of parallel batches (default: 3)
- Database pool settings:
  - `max`: Maximum connections (default: 20)
  - `min`: Minimum connections (default: 5)
  - `maxUses`: Connection recycle threshold (default: 7500)

## Troubleshooting

1. Database Connection Issues
   - Check Cloud SQL connection settings
   - Verify instance connection name
   - Check database credentials
   - Review connection pool settings

2. Slow Syncing
   - Increase `BATCH_SIZE` and `CONCURRENT_BATCHES`
   - Monitor database connection pool
   - Check network latency to Arch node
   - Review transaction processing patterns

3. Memory Issues
   - Increase Cloud Run memory allocation
   - Reduce batch sizes
   - Monitor memory usage patterns
   - Check for memory leaks in transaction processing

4. Cold Starts
   - Configure minimum instances > 0
   - Adjust concurrency settings
   - Monitor startup times
   - Review initialization process

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request
