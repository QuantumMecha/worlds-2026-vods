#!/usr/bin/env bash
# YouTube refuses to play embeds on pages opened as file:// or from a bare IP address,
# so serve this folder and open it via localhost (this computer) or a nip.io name (other devices).
cd "$(dirname "$0")"
ip=$(hostname -I | awk '{print $1}')
echo "This computer:  http://localhost:8026"
echo "Phone / other devices on the same Wi-Fi:  http://${ip//./-}.nip.io:8026"
echo "(Ctrl+C to stop)"
# Same as `python3 -m http.server`, but tells browsers never to reuse an old copy of the page.
python3 -c '
import http.server, socket
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()
class S(http.server.ThreadingHTTPServer):
    address_family = socket.AF_INET6
    def server_bind(self):
        self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
        super().server_bind()
S(("::", 8026), H).serve_forever()
'
