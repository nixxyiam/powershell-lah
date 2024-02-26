# Update Power Shell Help
# ============================================================================
# TROUBLESHOOTING NOTE
# If you have problems executing PowerShell scripts on your local machine, you
# may need to first perform a one-time relaxing of PowerShell Execution Policy
# with "Set-ExecutionPolicy -ExecutionPolicy Bypass" in PowerShell(Admin).
# You can check your current policy with "Get-ExecutionPolicy -List"
# =============================================================================

# ============================
# UPDATE POWERSHELL HELP FILES
# ============================

# Update PowerShell Help Database
Update-Help -Verbose -Force -ErrorAction SilentlyContinue

# Remove legacy Powershell 2.0
if ((Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root).State.ToString() -eq "Enabled") {
    Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online -Remove -NoRestart
}
