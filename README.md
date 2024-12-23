## CorsScanner
**CorsScanner** is a tool to scan web servers for potential Cross-Origin Resource Sharing (CORS) vulnerabilities. It supports scanning single URLs or multiple URLs from a file and logs any potential errors or vulnerabilities into a file named `corserrors.txt`.

## Features

- Detects misconfigured `Access-Control-Allow-Origin` headers.
- Checks for dangerous `Access-Control-Allow-Credentials` configurations.
- Supports scanning:
  - A single URL via the `-u` argument.
  - Multiple URLs from a text file via the `-i` argument.
- Outputs results to the terminal and logs errors/vulnerabilities to `corserrors.txt`.

## Requirements

### For Python Version:
- Python 3.x
- `requests` library (`pip install requests`)

### For Bash Version:
- Unix-based operating system (Linux, macOS, WSL)
- `curl` installed

## Installation 

### Clone the Repository
```bash
git clone https://github.com/yourusername/CorsScanner.git
cd CorsScanner
```
## Python Version Usage

### Run with a Single URL:
```
python3 CorsScanner.py -u https://example.com
```
### Run with a File of URLs:
Create a text file urls.txt with one URL per line:
```
https://example1.com
https://example2.com
```
Then, run:
```
python3 CorsScanner.py -i urls.txt
```
## Bash Version
### Make the Script Executable:
```
chmod +x CorsScanner.sh
```
### Run with a Single URL:
```
./CorsScanner.sh -u https://example.com
```
### Run with a File of URLs:
```
./CorsScanner.sh -i urls.txt
```

## Output

**Terminal Output**: Displays the scan results, including detected vulnerabilities or misconfigurations.
**Error Logging**: All errors and potential vulnerabilities are logged in corserrors.txt in the following format:
```
[https://example.com] Potential vulnerability: Access-Control-Allow-Origin allows all origins.
[https://example.com] Vulnerability: Access-Control-Allow-Credentials is set to true.
[Error] Unable to scan https://example.com: Connection timed out.
```
## Example Output
### Terminal:
```
Scanning https://example.com...
Access-Control-Allow-Origin: *
[!] Potential vulnerability: Access-Control-Allow-Origin allows all origins.
[-] Access-Control-Allow-Credentials is not set or set to false.

Scanning https://anotherexample.com...
Access-Control-Allow-Origin: evil.com
[!] Vulnerability: Access-Control-Allow-Credentials is set to true.
[!!] Exploitable: Server accepts credentials from malicious origins.
```
### Log file (corserrors.txt):
```
[https://example.com] Potential vulnerability: Access-Control-Allow-Origin allows all origins.
[https://anotherexample.com] Vulnerability: Access-Control-Allow-Credentials is set to true.
[https://anotherexample.com] Exploitable: Server accepts credentials from malicious origins.
```
## POC
You can use POC.html to exploit vulnerable URLs found by this code. Input the vulnerable URL and click the button. (Or you can always use burpsuite)

## Disclaimer
This tool is intended for educational purposes and security testing on websites you own or have permission to test. Unauthorized scanning may violate laws or terms of service. Use responsibly.
