# ==============================================================================
# MIT License
# 
# Copyright (c) 2023 Nicholas Ho
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==============================================================================

# ============================================================================
# TROUBLESHOOTING NOTE
# If you have problems executing PowerShell scripts on your local machine, you
# may need to first perform a one-time relaxing of PowerShell Execution Policy
# with "Set-ExecutionPolicy -ExecutionPolicy Bypass" in PowerShell(Admin).
# You can check your current policy with "Get-ExecutionPolicy -List"
# =============================================================================

# This script needs PowerShell(Admin) to execute.
# Check for Admin rights and quit script otherwise.
$currID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$currPrincipal = new-object System.Security.Principal.WindowsPrincipal($currID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if($currPrincipal.IsInRole($adminRole)) {

    # ===========================================
    # DETECT AND REPAIR ERRORS IN COMPONENT STORE
    # ===========================================
    # This cmdlet is equivalent to "DISM /Online /Cleanup-Image /CheckHealth",
    # "DISM /Online /Cleanup-Image /ScanHealth" and
    # "DISM /Online /Cleanup-Image /RestoreHealth".
   
    # Check for errors, and perform repairs if errors detected
    Write-Host "> Repair-WindowsImage -Online -CheckHealth"
    Repair-WindowsImage -Online -CheckHealth
   
    Write-Host "> Repair-WindowsImage -Online -ScanHealth"
    if ((Repair-WindowsImage -Online -ScanHealth).ImageHealthState -ne "Healthy") {
        Write-Host "ERRORS FOUND in Windows Component Store."
        Write-Host "> Repair-WindowsImage -Online -RestoreHealth"
        Repair-WindowsImage -Online -RestoreHealth
    } else {
        Write-Host "Windows Component Store is healthy."
    }


    # ================================================
    # DETECT AND REPAIR ERRORS IN WINDOWS SYSTEM FILES
    # ================================================
    # This PSscript invokes "sfc" in Command Prompt.
    # If you still still integrity violations detected after the second run of
    # sfc.exe, please manaully repeat "sfc.exe /scannow" until no more integrity
    # violations are detected in Windows system files.
    Write-Host "> sfc.exe /scannow"
    sfc.exe /scannow
    Write-Host "> sfc.exe /scannow"
    sfc.exe /scannow


    # =======================================
    # DETECT AND REPAIR ERRORS IN DISK VOLUME
    # =======================================
    # This cmdlet is equivalent to "chkdsk" in Command Prompt.

    # Check for errors, and invoke offline repairs if errors detected,
    # otherwise proceed to defrag/trim disk drive.
    Write-Host "> Repair-Volume -DriveLetter C -Scan"
    if ((Repair-Volume -DriveLetter C -Scan).value__ -eq 0) {
        Write-Host "Disk volume is healthy."

        # =============================
        # OPTIMIZE DISK I/O PERFORMANCE
        # =============================
        # Improve disk I/O performance of specified volume by performing either
        # defragmentation on HDD or TRIM on SSD. This PowerShell cmdlet automatically
        # detects disk type and applies appropriate optimisation technique.
        # This cmdlet is equivalent to "defrag" in Command Prompt.
        Write-Host "> Optimize-Volume -DriveLetter C -Verbose"
        Optimize-Volume -DriveLetter C -Verbose
    }
    else {
        Write-Host "ERRORS FOUND in disk volume, proceed to offline repairs."
        Write-Host "> Repair-Volume -DriveLetter C -OfflineScanAndFix"
        Repair-Volume -DriveLetter C -OfflineScanAndFix
    }
}
else {
    Write-Host "Please execute this PowerShell script in Admin privileges."
}