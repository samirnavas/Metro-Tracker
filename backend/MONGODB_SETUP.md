# MongoDB Setup for Metro Tracker

## Option 1: Install MongoDB Locally (Recommended for Development)

### Windows Installation

1. **Download MongoDB Community Edition:**
   - Visit: https://www.mongodb.com/try/download/community
   - Select: Windows x64, MSI installer
   - Download and run the installer

2. **Installation Steps:**
   - Choose "Complete" installation
   - **Important**: Check "Install MongoDB as a Service"
   - Service Name: MongoDB
   - Data Directory: `C:\Program Files\MongoDB\Server\7.0\data`
   - Log Directory: `C:\Program Files\MongoDB\Server\7.0\log`

3. **Verify Installation:**
   ```powershell
   # Check if MongoDB service is running
   Get-Service MongoDB
   
   # If not running, start it:
   Start-Service MongoDB
   
   # Or using net command (run as Administrator):
   net start MongoDB
   ```

4. **Test Connection:**
   ```bash
   # From your backend directory:
   npm run check-mongo
   ```

### Alternative: Manual Start

If you prefer not to install as a service:

```powershell
# Create data directory
mkdir C:\data\db

# Start MongoDB manually
mongod --dbpath="C:\data\db"
```

Keep this terminal open while developing.

## Option 2: Use MongoDB Atlas (Cloud - Free Tier)

1. **Create Account:**
   - Visit: https://www.mongodb.com/cloud/atlas/register
   - Sign up for free

2. **Create Cluster:**
   - Choose FREE tier (M0)
   - Select region closest to you
   - Click "Create Cluster"

3. **Set up Access:**
   - Database Access → Add New User
     - Username: `metro_admin`
     - Password: (generate strong password)
     - Role: Read and write to any database
   
   - Network Access → Add IP Address
     - Click "Allow Access from Anywhere" (for development)
     - Or add your specific IP

4. **Get Connection String:**
   - Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string:
     ```
     mongodb+srv://metro_admin:<password>@cluster0.xxxxx.mongodb.net/metro-tracker?retryWrites=true&w=majority
     ```

5. **Update .env:**
   ```env
   MONGODB_URI=mongodb+srv://metro_admin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/metro-tracker?retryWrites=true&w=majority
   ```

## After MongoDB is Running

1. **Verify Connection:**
   ```bash
   npm run check-mongo
   ```

2. **Seed the Database:**
   ```bash
   npm run seed
   ```

   Expected output:
   ```
   🌱 Starting database seed...
   ✓ MongoDB connected successfully
   🗑️  Clearing existing data...
   ✓ Existing data cleared

   📍 Creating Metro stations...
   ✓ Created 25 metro stations

   📍 Creating Feeder bus stations...
   ✓ Created 6 feeder stations

   🚇 Creating Metro Line 1 route...
   ✓ Created route: Kochi Metro Line 1

   🚌 Creating Feeder bus route...
   ✓ Created route: Aluva Feeder Route 1

   🚊 Creating sample vehicles...
   ✓ Created 4 vehicles

   📊 Seed Summary:
   ─────────────────────────────
   Metro Stations: 25
   Feeder Stations: 6
   Routes: 2 (1 Metro, 1 Bus)
   Vehicles: 4 (2 Metro, 2 Bus)
   ─────────────────────────────

   ✅ Database seeded successfully!
   ```

3. **Start the Server:**
   ```bash
   npm run dev
   ```

## Troubleshooting

### "Cannot connect to MongoDB"

1. **Check if MongoDB is running:**
   ```powershell
   Get-Service MongoDB
   ```

2. **Start the service:**
   ```powershell
   Start-Service MongoDB
   ```

3. **Check port 27017:**
   ```powershell
   netstat -an | findstr 27017
   ```

### "Connection timeout"

- If using Atlas: Check Network Access settings
- If using local: Make sure MongoDB service is running
- Check firewall settings

### "Authentication failed"

- Verify username/password in connection string
- Make sure user has proper permissions in Atlas

## Quick Reference

```bash
# Check MongoDB status
npm run check-mongo

# Seed/reset database
npm run seed

# Start development server
npm run dev

# View MongoDB data (if mongosh is installed)
mongosh
> use metro-tracker
> db.stations.find()
> db.vehicles.find()
```

## Next Steps

Once MongoDB is set up and seeded:
1. Your backend will be ready at `http://localhost:8080`
2. WebSocket will be available at `ws://localhost:8080`
3. You can proceed with Flutter app integration
