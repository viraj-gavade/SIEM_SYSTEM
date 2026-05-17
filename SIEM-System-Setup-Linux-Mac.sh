#!/bin/bash

set -e

clear
echo "=================================================="
echo "        SIEM System v1.1.1 - macOS/Linux Setup"
echo "=================================================="
echo ""
echo "=================================================="
echo "IMPORTANT: If macOS blocks this script:"
echo "  1. Open System Settings → Privacy & Security"
echo "  2. Scroll to Security section"
echo "  3. Click 'Allow Anyway' next to setup.sh"
echo "  OR run: xattr -d com.apple.quarantine setup.sh"
echo "=================================================="
echo ""

sleep 3

echo ""
echo "[Step 1/6] Checking system requirements..."
echo ""

echo "Checking for Docker..."
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker not found!"
    echo ""
    echo "Please install Docker Desktop first:"
    echo "  - macOS: https://www.docker.com/products/docker-desktop"
    echo "  - Linux: https://docs.docker.com/engine/install/"
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi
echo "OK: Docker is installed"
echo ""

echo "Checking if Docker is running..."
if ! docker info &> /dev/null; then
    echo "ERROR: Docker is not running!"
    echo ""
    echo "Please start Docker Desktop and try again."
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi
echo "OK: Docker is running"
echo ""

echo "Checking internet connection..."
if ! ping -c 2 github.com &> /dev/null; then
    echo "ERROR: No internet connection!"
    echo ""
    echo "Please check your internet connection and try again."
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi
echo "OK: Internet connection available"
echo ""

echo "=================================================="
echo "All system checks passed!"
echo "=================================================="
echo ""

echo "[Step 2/6] Downloading docker-compose.yml..."
echo ""

if command -v curl &> /dev/null; then
    curl -fsSL -o docker-compose.yml https://raw.githubusercontent.com/viraj-gavade/SIEM_SYSTEM/main/docker-compose.yml
elif command -v wget &> /dev/null; then
    wget -q -O docker-compose.yml https://raw.githubusercontent.com/viraj-gavade/SIEM_SYSTEM/main/docker-compose.yml
else
    echo "ERROR: Neither curl nor wget found!"
    echo ""
    echo "Please install curl and try again."
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

if [ ! -f docker-compose.yml ]; then
    echo ""
    echo "ERROR: Failed to download docker-compose.yml!"
    echo ""
    echo "Please check your internet connection and try again."
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

echo "OK: Downloaded docker-compose.yml successfully!"
echo ""

echo "[Step 3/6] Checking for existing containers..."
echo ""

if docker compose -p siem-system ps -q &> /dev/null; then
    echo "Found existing containers - stopping them first..."
    docker compose -p siem-system down &> /dev/null
    echo "OK: Existing containers stopped"
fi
echo ""

echo "[Step 4/6] Pulling Docker images (this may take a few minutes)..."
echo ""

if ! docker compose -p siem-system pull; then
    echo ""
    echo "ERROR: Failed to pull Docker images!"
    echo ""
    echo "Try manually:"
    echo "  docker compose -p siem-system pull"
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""
echo "OK: All images pulled successfully!"
echo ""

echo "[Step 5/6] Starting SIEM System..."
echo ""

if ! docker compose -p siem-system up -d; then
    echo ""
    echo "ERROR: Failed to start SIEM System!"
    echo ""
    echo "Check logs with:"
    echo "  docker compose -p siem-system logs"
    echo ""
    echo "For help, contact: vrajgavade17@gmail.com"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""
echo "OK: SIEM System started successfully!"
echo ""

echo "[Step 6/6] Waiting for services to be ready..."
echo "This will take about 30-60 seconds..."

sleep 45

echo ""
echo "=================================================="
echo "SIEM SYSTEM SETUP COMPLETE!"
echo "=================================================="
echo ""
echo "Dashboard: http://localhost:3000"
echo ""
echo "Useful Commands:"
echo ""
echo "  Stop system:"
echo "  docker compose -p siem-system down"
echo ""
echo "  View logs:"
echo "  docker compose -p siem-system logs -f"
echo ""
echo "  Check status:"
echo "  docker compose -p siem-system ps"
echo ""
echo "Need help? Contact: vrajgavade17@gmail.com"
echo ""

echo "Opening dashboard in your browser..."
sleep 3

if command -v open &> /dev/null; then
    # macOS
    open http://localhost:3000
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://localhost:3000
else
    echo "Please open http://localhost:3000 in your browser manually."
fi

echo ""
read -p "Press Enter to exit..."
