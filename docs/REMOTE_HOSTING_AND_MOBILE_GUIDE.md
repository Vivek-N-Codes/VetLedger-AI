# VetLedger AI — Remote Hosting & Mobile Deployment Guide

This guide explains how to host the **VetLedger AI** backend remotely and connect the Flutter mobile app from any device (physical Android phone, iOS device, web browser, or cloud VM).

---

## 🌐 Option 1: Instant Mobile Testing Over Local Wi-Fi (Same Network)

If your laptop and mobile device are connected to the same Wi-Fi router:

### 1. Find Your Machine's Local IP Address
In PowerShell on Windows:
```powershell
ipconfig
```
Look for **IPv4 Address** (e.g., `192.168.1.15`).

### 2. Verify Firewall Permits Port 8080
Ensure Windows Firewall permits incoming connections on port 8080:
```powershell
netsh advfirewall firewall add rule name="VetLedger API" dir=in action=allow protocol=TCP localport=8080
```

### 3. Connect from Mobile App
- Launch the Flutter app on your phone:
  ```powershell
  cd mobile
  flutter run
  ```
- **Tap the Network Settings icon** (top-right of the app bar: ⚙️ / 🔀).
- Change the URL to:
  ```text
  http://192.168.1.15:8080/api
  ```
- Tap **"Save & Apply"**. The app immediately reloads data from your machine's live database.

---

## 🚀 Option 2: Instant Public URL with Ngrok (Global Access)

To make your local backend reachable from **any phone anywhere in the world** (over 4G/5G mobile data) without hosting yet:

1. Start your local Spring Boot backend on port 8080.
2. In a new terminal, launch ngrok (or cloudflared):
   ```powershell
   ngrok http 8080
   ```
3. Copy your public forwarding URL (e.g., `https://a1b2-c3d4.ngrok-free.app`).
4. In the mobile app:
   - Tap the Network Settings icon in the app bar.
   - Enter `https://a1b2-c3d4.ngrok-free.app/api`.
   - Tap **"Save & Apply"**.

---

## ☁️ Option 3: Deploy to Cloud (Render / Railway / Cloud Run / VPS)

### Deploying via Docker Compose (Any Linux VPS / DigitalOcean / AWS EC2)
The repository includes a ready-to-use [docker-compose.yml](file:///d:/Hackathons/VetLedger-AI/docker-compose.yml):

```bash
git clone https://github.com/Vivek-N-Codes/VetLedger-AI.git
cd VetLedger-AI
docker compose up -d --build
```
This automatically boots:
- PostgreSQL 16 container with automatic schema & seed data loading.
- Spring Boot container on port 8080 with health checks enabled.

### Deploying via Render / Railway (Free & Low-Cost PaaS)
1. Link your GitHub repository: `https://github.com/Vivek-N-Codes/VetLedger-AI`
2. Create a **PostgreSQL** service:
   - Run `database/schema.sql` and `database/seed_data.sql` in the query console.
3. Create a **Web Service**:
   - Root directory: `backend/`
   - Build command: `mvn clean package -DskipTests` (or select Dockerfile)
   - Environment variables:
     - `SPRING_DATASOURCE_URL`: your PostgreSQL connection string
     - `SPRING_DATASOURCE_USERNAME`: your DB user
     - `SPRING_DATASOURCE_PASSWORD`: your DB password
     - `GEMINI_API_KEY`: *(Optional)* for live Gemini LLM clinical intelligence

---

## 📱 Option 4: Build Standalone Mobile APK for Android

To produce an installable `.apk` file that anyone can install directly on an Android smartphone:

```powershell
cd mobile

# Build release APK pointing to your remote backend URL:
flutter build apk --release --dart-define=API_URL=https://your-backend-url.com/api
```

The compiled APK will be created at:
```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```
Transfer this file to any Android device via WhatsApp, Google Drive, or USB and tap to install!
