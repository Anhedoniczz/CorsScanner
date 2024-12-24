import argparse
import requests

def log_error(message):
    with open("corserrors.txt", "a") as file:
        file.write(message + "\n")

def scan_cors(url):
    headers = {
        "Origin": "evil.com",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0",
    }

    try:
        print(f"\nScanning {url}...")
        response = requests.get(url, headers=headers, timeout=5)
        cors_headers = response.headers

        aca_origin = cors_headers.get("Access-Control-Allow-Origin")
        if aca_origin:
            print(f"Access-Control-Allow-Origin: {aca_origin}")
            if aca_origin == "evil.com":
                message = f"[{url}] vulnerability: Access-Control-Allow-Origin allowed evil.com Origin."
                print(message)
                log_error(message)
        else:
            message = f"[{url}] Access-Control-Allow-Origin not found."
            print(message)

        aca_credentials = cors_headers.get("Access-Control-Allow-Credentials")
        if aca_credentials == "true":
            message = f"[{url}] Vulnerability: Access-Control-Allow-Credentials is set to true."
            print(message)
            if aca_origin == "evil.com":
                message = f"[{url}] Exploitable: Server accepts credentials from malicious origins."
                print(message)
                log_error(message)
    except requests.exceptions.Timeout:
        message = f"[{url}] Error: Request timed out after 5 seconds."
        print(message)
        log_error(message)
    except Exception as e:
        message = f"[{url}] Error: {str(e)}"
        print(message)
        log_error(message)

def main():
    parser = argparse.ArgumentParser(description="CORS Exploit Scanner")
    parser.add_argument("-u", "--url", help="Scan a single URL")
    parser.add_argument("-i", "--input", help="File containing multiple URLs (one per line)")

    args = parser.parse_args()

    if args.url:
        scan_cors(args.url)
    elif args.input:
        try:
            with open(args.input, "r") as file:
                urls = file.readlines()
                for url in urls:
                    scan_cors(url.strip())
        except FileNotFoundError:
            message = f"[Error] File '{args.input}' not found."
            print(message)
            log_error(message)
    else:
        print("[Error] You must provide either a URL with -u or a file with -i.")
        parser.print_help()

if __name__ == "__main__":
    main()
