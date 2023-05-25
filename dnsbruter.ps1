

# This script bruteforces subdomains of a given domain.

# Import the `Resolve-DnsName` cmdlet.
Import-Module DnsClient

# Get the wordlist.
$wordlist = Get-Content wordlist.txt

# Get the list of top-level domains.
$tlds = Get-Content tlds.txt

# Create a new thread pool.
$threadPool = New-Object System.Threading.ThreadPool

# Loop through the wordlist and top-level domains.
ForEach ($word in $wordlist) {
  foreach ($tld in $tlds) {

    # Try to resolve the subdomain.
    $ipAddress = Resolve-DnsName -Name $word + $tld -ErrorAction Continue

    # If the subdomain is resolved, print it to the console and save it to a file.
    If ($ipAddress) {
      if ($verbosity -ge 1) {
        Write-Host -ForegroundColor Green "$word.trim() [founded]"
      }
      if ($verbosity -ge 2) {
        Write-Host $ipAddress.IPAddressToString()
      }
      $results += [pscustomobject]@{
        subdomain = $word.trim()
        ipAddress = $ipAddress.IPAddressToString()
        author = "Hithmast"
      }
    }

    # Sleep for the specified interval.
    Start-Sleep $sleepInterval
  }
}

# Wait for all threads to finish.
$threadPool.WaitForAll()

# Save the results to a file if the `-Output` argument is specified.
If ($args[0] -eq "-Output") {
  $results | ConvertTo-Json -Depth 1 | Out-File $args[1]
}

# Print the help message if no arguments are specified.
If ($args.Count -eq 0) {
  Write-Host "Usage: bruteforce-subdomains [-Domain] [-Wordlist] [-Output] [-Silent] [-Sleep] [-Verbose]"
  Write-Host "-Domain The domain to bruteforce subdomains for."
  Write-Host "-Wordlist The wordlist to use to generate subdomains."
  Write-Host "-Output The file to save the results to."
  Write-Host "-Silent Do not print anything to the console."
  Write-Host "-Sleep The number of seconds to sleep between DNS lookups."
  Write-Host "-Verbose The level of verbosity."
}

# Check if the `-Silent` argument is specified.
if ($args[0] -eq "-Silent") {
  # Do not print anything to the console.
  $ErrorActionPreference = "SilentlyContinue"
}

# Check if the `-Sleep` argument is specified.
if ($args[0] -eq "-Sleep") {
  # Set the sleep interval.
  $sleepInterval = $args[1]
}
else {
  # Set the default sleep interval.
  $sleepInterval = 1
}

# Check if the `-Verbose` argument is specified.
if ($args[0] -eq "-Verbose") {
  # Set the verbosity level.
  $verbosity = $args[1]
}
else {
  # Set the default verbosity level.
  $verbosity = 1
}

# Start the bruteforce process.
Start-Job -ScriptBlock {
  # Get the wordlist and top-level domains.
  $wordlist = Get-Content wordlist.txt
  $tlds = Get-Content tlds.txt

  # Create a new thread pool.
  $threadPool = New-Object System.Threading.ThreadPool

  # Loop through the wordlist and top-level domains.
  ForEach ($word in $wordlist) {
    foreach ($tld in $tlds) {

      # Try to resolve the subdomain.
      $ipAddress = Resolve-DnsName -Name $word + $tld -ErrorAction Continue

      # If the subdomain is resolved, print it to the console and save it to a file.
      If ($ipAddress) {
        if ($verbosity -ge 1) {
          Write-Host -ForegroundColor Green "$word.trim() [founded]"
        }
        if ($verbosity -ge 2) {
          Write-Host $ipAddress.IPAddressToString()
          }

        $results +=
