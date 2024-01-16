from http.server import HTTPServer, SimpleHTTPRequestHandler
from functools import partial

class CORSHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        SimpleHTTPRequestHandler.end_headers(self)

if __name__ == '__main__':
    # Set the directory you want to serve
    directory_to_serve = 'C:/Users/nmw59/Desktop/wqf'  # Update this to your folder path
    
    handler_class = partial(CORSHTTPRequestHandler, directory=directory_to_serve)
    server_address = ('', 8000)  # Serve on localhost, port 8000
    httpd = HTTPServer(server_address, handler_class)
    
    print(f"Serving at http://localhost:8000 from {directory_to_serve}")
    httpd.serve_forever()
