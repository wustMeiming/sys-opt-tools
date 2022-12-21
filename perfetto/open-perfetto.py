import os
import socketserver
import webbrowser
import http.server
import argparse

# HTTP Server used to open the trace in the browser.
class HttpHandler(http.server.SimpleHTTPRequestHandler):

  def end_headers(self):
    self.send_header('Access-Control-Allow-Origin', '*')
    return super().end_headers()

  def do_GET(self):
    self.server.last_request = self.path
    return super().do_GET()

  def do_POST(self):
    self.send_error(404, "File not found")

def open_trace_in_browser(path):
  # We reuse the HTTP+RPC port because it's the only one allowed by the CSP.
  PORT = 9001
  os.chdir(os.path.dirname(path))
  fname = os.path.basename(path)
  socketserver.TCPServer.allow_reuse_address = True
  with socketserver.TCPServer(('127.0.0.1', PORT), HttpHandler) as httpd:
    webbrowser.open_new_tab(
        'https://ui.perfetto.dev/#!/?url=http://127.0.0.1:%d/%s' %
        (PORT, fname))
    while httpd.__dict__.get('last_request') != '/' + fname:
      httpd.handle_request()

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("-t", "--trace", help="trace file path")
  args = parser.parse_args()
  open_trace_in_browser(args.trace)

if __name__ == "__main__":
  main()
  
