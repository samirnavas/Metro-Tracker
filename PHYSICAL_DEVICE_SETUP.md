# Metro Tracker - Physical Device Setup Guide

## 🎯 Quick Setup for Physical Android Device

### Step 1: Find Your Computer's IP Address

**Windows:**
```bash
ipconfig
```
Look for "IPv4 Address" under your active network adapter (usually starts with 192.168.x.x)

**Mac/Linux:**
```bash
ifconfig
# or
ip addr
```

### Step 2: Update Flutter App Configuration

Open this file:
```
metro_tracker_app/lib/injection_container.dart
```

Update these two lines (around line 66-67):
```dart
const bool usePhysicalDevice = true; // Keep as true for physical device
const String localIpAddress = 'YOUR_IP_HERE'; // Replace with your computer's IP
```

**Example:**
```dart
const bool usePhysicalDevice = true;
const String localIpAddress = '192.168.1.100'; // Your actual IP
```

### Step 3: Ensure Backend is Running

The backend server is already configured to accept connections from the network.
When you start the backend with `npm run dev`, it will display:

```
📱 FOR PHYSICAL DEVICE:
   HTTP Server: http://192.168.x.x:8080
   WebSocket: ws://192.168.x.x:8080
   
💡 TIP: Update Flutter app's localIpAddress to: 192.168.x.x
```

Copy that IP address and paste it into `injection_container.dart`

### Step 4: Connect Physical Device

1. **Connect your Android phone to the SAME WiFi network as your computer**
2. **Enable USB Debugging** on your phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times to enable Developer Options
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"
3. **Connect via USB** and run:
   ```bash
   flutter run
   ```

### 🔧 Switching Between Emulator and Physical Device

**For Android Emulator:**
```dart
const bool usePhysicalDevice = false; // Use emulator
```

**For Physical Device:**
```dart
const bool usePhysicalDevice = true; // Use physical device
const String localIpAddress = 'YOUR_COMPUTER_IP'; // Your IP
```

### ✅ Testing the Connection

1. Start the backend server (it should already be running)
2. Note the IP address displayed in the server logs
3. Update `localIpAddress` in Flutter app
4. Run the app on your physical device
5. The app should connect and load metro data

### 🚨 Troubleshooting

**App not connecting?**
- ✓ Both devices on SAME WiFi network?
- ✓ Firewall blocking port 8080?
  - Windows: Allow Node.js through Windows Firewall
  - Mac: System Preferences → Security & Privacy → Firewall
- ✓ IP address correct in `injection_container.dart`?
- ✓ Backend server running?

**How to allow through Windows Firewall:**
```bash
# Run as Administrator
netsh advfirewall firewall add rule name="Node.js Server" dir=in action=allow protocol=TCP localport=8080
```

### 📝 Current Configuration

**Backend:** Already configured to listen on all network interfaces (0.0.0.0:8080)
**Flutter App:** Update `localIpAddress` in `injection_container.dart`
**Port:** 8080 (both HTTP and WebSocket)

---

## 🔄 Quick Reference

| Setup Type | Configuration |
|------------|--------------|
| Physical Device | `usePhysicalDevice = true`<br>`localIpAddress = 'YOUR_IP'` |
| Android Emulator | `usePhysicalDevice = false` |
| iOS Simulator | Default (uses localhost) |
| Web | Default (uses localhost) |
