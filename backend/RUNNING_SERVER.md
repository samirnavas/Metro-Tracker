# Metro Tracker Backend - Server Instructions

## ⚠️ Current Issue: Port Already in Use

You're seeing the error `[nodemon] app crashed` because **two instances** of the server are trying to run on the same port (8080).

### What's Happening

You have two terminal commands running:
1. `npm start` - Started 5 minutes ago, **currently using port 8080** ✅
2. `npm run dev` - Trying to start, but **failing** because port 8080 is already taken ❌

### Solution: Choose ONE

You only need **one** server running at a time. Here are your options:

---

## Option 1: Use `npm start` (No Auto-Reload)

**What it does**: Runs the server without automatic restart on file changes.

**When to use**: When you're just running the app and not actively editing backend code.

**Steps**:
1. Stop the `npm run dev` terminal (Ctrl+C or close it)
2. Keep `npm start` running
3. ✅ Server is accessible at `http://localhost:8080` or `http://YOUR_IP:8080`

---

## Option 2: Use `npm run dev` (With Auto-Reload) ⭐ RECOMMENDED

**What it does**: Runs the server with nodemon, which automatically restarts when you edit code.

**When to use**: When you're actively developing and editing backend files.

**Steps**:
1. **Stop the existing `npm start`** process:
   - Press `Ctrl+C` in that terminal
   - Or close that terminal window
   
2. **Start the dev server**:
   ```bash
   npm run dev
   ```

3. ✅ Server will start on `http://localhost:8080`

---

## How to Stop a Terminal Process

If you see two servers running, here's how to stop one:

### In the Terminal
1. Click on the terminal running the command
2. Press `Ctrl+C` to stop it

### Using Task Manager (if terminal is stuck)
1. Press `Ctrl+Shift+Esc` to open Task Manager
2. Find the process with PID `5940` (or the current PID)
3. Right-click → End Task

### Using Command Line
```bash
# Kill process by PID (replace 5940 with actual PID)
taskkill /F /PID 5940
```

---

## Quick Check: Is the Server Running?

```bash
# Check what's using port 8080
netstat -ano | findstr :8080

# Test if server is responding
curl http://localhost:8080/health
```

---

## Server is Working! ✅

Once you stop one instance and keep only one running, you should see:

```
✅ Server Ready!
─────────────────────────────────────────────────
📱 FOR PHYSICAL DEVICE:
   HTTP Server: http://YOUR_IP:8080
   WebSocket: ws://YOUR_IP:8080
   
💻 FOR LOCALHOST/WEB:
   HTTP Server: http://localhost:8080
   WebSocket: ws://localhost:8080
   
📡 API ENDPOINTS:
   Routes: http://YOUR_IP:8080/api/routes
   Stations: http://YOUR_IP:8080/api/stations
   Vehicles: http://YOUR_IP:8080/api/vehicles
   Timetables: http://YOUR_IP:8080/api/timetables
─────────────────────────────────────────────────
```

---

## Environment Variables

Make sure your `.env` file has:
```env
MONGODB_URI=your_mongodb_connection_string
PORT=8080
SIMULATION_INTERVAL=3000
```

If you want to use a different port, change `PORT=8080` to another port like `PORT=5000`.

---

## Summary

**Right now**: Stop the old `npm start` and just run `npm run dev` for development. ✅

**The error will go away** once only one server is running!
