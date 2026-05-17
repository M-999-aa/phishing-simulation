# Phishing Simulation Project

> **Educational project** built for a Bash Scripting & System Programming course at Prince Mohammad Bin Fahd University.  
> The entire project runs locally on `localhost` — no real users or real websites were involved at any point.

**Author:** Marwan Alkouji  
**Date:** May 2026

---

## 📌 Introduction

A phishing attack tricks a user into entering their credentials on a fake website that looks like the real one. This project simulates that process in a fully local, controlled environment to understand:

- How fake login pages work
- How a web server handles form data
- How Bash scripts can automate tasks

---

## 🗂️ Project Structure

```
phishing-simulation/
├── server.py          # Python web server (handles GET & POST)
├── login.sh           # Bash automation script
├── login.html         # Active login page (copied by script)
├── credentials.txt    # Captured credentials log
├── curl_log.txt       # curl request log
└── pages/             # HTML login page templates
```

---

## ⚙️ How It Works

The project has three main components:

### 1. Web Server — `server.py`
A Python web server that listens on port **8080** with two jobs:
- **GET request** → reads `login.html` and sends it to the browser
- **POST request** → receives the submitted username and password, prints them in the terminal, and saves them to `credentials.txt` with a timestamp

### 2. Bash Script — `login.sh`
Automates the entire workflow using several Bash concepts:

| Concept | Purpose |
|---|---|
| `for` loop | Automatically finds all HTML files in the project folder |
| Arrays | Stores HTML filenames and displays them as a numbered menu |
| `read` command | Gets user input; `-s` flag hides the password while typing |
| `if` statement | Checks if the server is running before continuing |
| `cp` command | Copies the selected HTML file and renames it to `login.html` |
| `curl` command | Sends credentials as a POST request to the local server |
| `date` command | Adds a timestamp to every saved credential |
| `>>` operator | Appends new entries to the log file without overwriting |
| `chmod +x` | Makes the script executable |

### 3. Login Pages — HTML/CSS
Multiple fake login pages built with HTML and CSS. The form on each page is configured to submit data to the local server instead of the real website.

---

## 🚀 How to Run

Open **two terminal windows** inside the project folder.

### Terminal 1 — Start the Server
```bash
python3 server.py
```
Leave this running. It will wait for incoming requests and print captured credentials in real time.

### Terminal 2 — Run the Script
```bash
chmod +x login.sh   # first time only
./login.sh
```
A menu will appear listing all available HTML login pages. After selecting a page, the script asks for a username and password, sends them to the server via `curl`, and saves them to:
- `credentials.txt`
- `curl_log.txt`

---

## 📚 What I Learned

This project provided hands-on practice with:

- **Bash scripting** — loops, arrays, conditionals, input handling, file I/O
- **Linux** — file permissions, process checking, command chaining
- **Python** — building a basic HTTP server handling GET and POST requests
- **HTML/CSS** — structuring and styling web forms
- **Networking** — understanding how browsers submit form data via HTTP POST

---

## 🎓 Conclusion

Building this phishing simulation from scratch provided practical experience across Bash scripting, Linux, Python, HTML, and basic networking — all in one project. Understanding how attacks are constructed is the first step toward being able to defend against them.

---

> **Disclaimer:** This project was built strictly for educational purposes as part of a university course. It runs entirely on localhost and was never used against real users or systems.
