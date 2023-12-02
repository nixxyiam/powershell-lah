# Use powershell-lah Repository

This is a collection of PowerShell knowledge to improve personal productivity at
home or at office. The more complicated processes are automated into scripts,
while the simpler ones are listed here for easy reference.

The key motivation for this repository is to use Windows 11 PowerShell
components, without the need to install third-party software, to facilitate
common activities undertaken by a computer power user.

## Home PC Maintenance

- FixWindowsSystem.ps1  
  Script to automate repairs of errors and corruption found on Windows image,
  system files and file system. The script will run repair tools, which are
  already included in Windows 11, to detect errors and repair if necessary. The
  repair process involves the following:

  - [Repair-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/repair-windowsimage)
    cmdlet (equivalent to DISM tool) to repair errors in Windows images
  - [SFC](https://learn.microsoft.com/en-us/troubleshoot/windows-server/deployment/system-file-checker)
    tool to repair errors in Windows system files
  - [Repair-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/repair-volume)
    cmdlet (equivalent to CHKDSK tool) to repair file system of a volume
  - [Optimize-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/optimize-volume)
    cmdlet (equivalent to DEFRAG tool) to defrag HDD or retrim SSD

## Developer Workflow

1. Generate a Globally Unique Identifier (GUID) in PowerShell  
   You can generate a new GUID in PowerShell using

    ```powershell
    [guid]::NewGuid()
    ```

   Alternatively, you can also output GUID in Registry format using

   ```powershell
   '{'+[guid]::NewGuid().ToString()+'}'
   ```
