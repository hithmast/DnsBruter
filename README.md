# DnsBruter

# Bruteforce Subdomains

This script bruteforces subdomains of a given domain.

## Usage

`bruteforce-subdomains` [-Domain] [-Wordlist] [-Output] [-Silent] [-Sleep] [-Verbose]

## Arguments

* **-Domain** The domain to bruteforce subdomains for.
* **-Wordlist** The wordlist to use to generate subdomains.
* **-Output** The file to save the results to.
* **-Silent** Do not print anything to the console.
* **-Sleep** The number of seconds to sleep between DNS lookups.
* **-Verbose** The level of verbosity.

## Example


```
dnsbruter.ps1 -Domain example.com -Wordlist wordlist.txt -Output results.txt
```
This will bruteforce all subdomains of example.com using the wordlist wordlist.txt and save the results to the file results.txt.

Author
This script was created by Ali Emara (Hithmast).
