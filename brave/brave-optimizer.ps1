# ==============================================================================
# AMAR_AI PRIME - FIXED RE-ENGINEERED GUI PRODUCTION BUILD (v5.0 - Final)
# FRAMEWORK: (State) -> (Command) -> (Expected Result)
# ==============================================================================

# --- ELEVATION CORE ENGINE ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -STA -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Safe Assembly Loading
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

# Target Path Definition
$RegistryPath = 'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave'
if (-not (Test-Path -Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }

# ==============================================================================
# MAIN GUI ARCHITECTURE (Re-sized Safely to Prevent Bound Overflow)
# ==============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Amar_ai Prime - SlimBrave Optimizer vFinal'
$form.Size = New-Object System.Drawing.Size(820, 780) # Increased to handle all controls safely
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(255, 20, 20, 20)
$form.MaximizeBox = $false
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$allFeatures = @()

# Left Column Panel (With AutoScroll enabled just in case)
$leftPanel = New-Object System.Windows.Forms.Panel
$leftPanel.Location = New-Object System.Drawing.Point(20, 20)
$leftPanel.Size = New-Object System.Drawing.Size(370, 520)
$leftPanel.BackColor = [System.Drawing.Color]::FromArgb(255, 30, 30, 30)
$leftPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$leftPanel.AutoScroll = $true # Secure fallback against overflow crash
$form.Controls.Add($leftPanel)

# Right Column Panel
$rightPanel = New-Object System.Windows.Forms.Panel
$rightPanel.Location = New-Object System.Drawing.Point(410, 20)
$rightPanel.Size = New-Object System.Drawing.Size(370, 520)
$rightPanel.BackColor = [System.Drawing.Color]::FromArgb(255, 30, 30, 30)
$rightPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$form.Controls.Add($rightPanel)

# Live Output Monitor
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(20, 560)
$logBox.Size = New-Object System.Drawing.Size(760, 100)
$logBox.Multiline = $true
$logBox.ReadOnly = $true
$logBox.ScrollBars = 'Vertical'
$logBox.BackColor = [System.Drawing.Color]::FromArgb(255, 10, 10, 10)
$logBox.ForeColor = [System.Drawing.Color]::LimeGreen
$logBox.Font = New-Object System.Drawing.Font('Consolas', 9)
$logBox.Text = " [SYSTEM ADMIN READY] Threading Apartment initialized safely. Awaiting interaction...`r`n"
$form.Controls.Add($logBox)

# --- PANEL 1: TELEMETRY ---
$telemetryLabel = New-Object System.Windows.Forms.Label
$telemetryLabel.Text = 'Telemetry & Reporting'
$telemetryLabel.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$telemetryLabel.Location = New-Object System.Drawing.Point(15, 15)
$telemetryLabel.Size = New-Object System.Drawing.Size(300, 25)
$telemetryLabel.ForeColor = [System.Drawing.Color]::LightSalmon
$leftPanel.Controls.Add($telemetryLabel)

$telemetryFeatures = @(
   @{ Name = 'Disable Metrics Reporting'; Key = 'MetricsReportingEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Safe Browsing Reporting'; Key = 'SafeBrowsingExtendedReportingEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable URL Data Collection'; Key = 'UrlKeyedAnonymizedDataCollectionEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Feedback Surveys'; Key = 'FeedbackSurveysEnabled'; Value = 0; Type = 'DWord' }
)

$currentY = 45
foreach ($feature in $telemetryFeatures) {
   $checkbox = New-Object System.Windows.Forms.CheckBox
   $checkbox.Text = $feature.Name
   $checkbox.Tag = $feature
   $checkbox.Font = New-Object System.Drawing.Font('Segoe UI', 9)
   $checkbox.Location = New-Object System.Drawing.Point(20, $currentY)
   $checkbox.Size = New-Object System.Drawing.Size(320, 22)
   $checkbox.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
   $checkbox.ForeColor = [System.Drawing.Color]::Gainsboro
   $leftPanel.Controls.Add($checkbox)
   $allFeatures += $checkbox
   $currentY += 25
}

# --- PANEL 1: PRIVACY ---
$currentY += 15
$privacyLabel = New-Object System.Windows.Forms.Label
$privacyLabel.Text = 'Privacy & Security'
$privacyLabel.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$privacyLabel.Location = New-Object System.Drawing.Point(15, $currentY)
$privacyLabel.Size = New-Object System.Drawing.Size(300, 25)
$privacyLabel.ForeColor = [System.Drawing.Color]::LightSalmon
$leftPanel.Controls.Add($privacyLabel)
$currentY += 30

$privacyFeatures = @(
   @{ Name = 'Disable Safe Browsing'; Key = 'SafeBrowsingProtectionLevel'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Autofill (Addresses)'; Key = 'AutofillAddressEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Autofill (Credit Cards)'; Key = 'AutofillCreditCardEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Password Manager'; Key = 'PasswordManagerEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Browser Sign-in'; Key = 'BrowserSignin'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable WebRTC IP Leak'; Key = 'WebRtcIPHandling'; Value = 'disable_non_proxied_udp'; Type = 'String' },
   @{ Name = 'Disable QUIC Protocol'; Key = 'QuicAllowed'; Value = 0; Type = 'DWord' },
   @{ Name = 'Block Third Party Cookies'; Key = 'BlockThirdPartyCookies'; Value = 1; Type = 'DWord' },
   @{ Name = 'Enable Do Not Track'; Key = 'EnableDoNotTrack'; Value = 1; Type = 'DWord' },
   @{ Name = 'Force Google SafeSearch'; Key = 'ForceGoogleSafeSearch'; Value = 1; Type = 'DWord' },
   @{ Name = 'Disable IPFS Network Protocol'; Key = 'IPFSEnabled'; Value = 0; Type = 'DWord' },
   @{ Name = 'Disable Incognito Mode'; Key = 'IncognitoModeAvailability'; Value = 1; Type = 'DWord' }
)

foreach ($feature in $privacyFeatures) {
   $checkbox = New-Object System.Windows.Forms.CheckBox
   $checkbox.Text = $feature.Name
   $checkbox.Tag = $feature
   $checkbox.Font = New-Object System.Drawing.Font('Segoe UI', 9)
   $checkbox.Location = New-Object System.Drawing.Point(20, $currentY)
   $checkbox.Size = New-Object System.Drawing.Size(320, 22)
   $checkbox.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
   $checkbox.ForeColor = [System.Drawing.Color]::Gainsboro
   $leftPanel.Controls.Add($checkbox)
   $allFeatures += $checkbox
   $currentY += 25
}

# --- PANEL 2: DNS ENGINE ---
$dnsLabel = New-Object System.Windows.Forms.Label
$dnsLabel.Text = 'Secure DNS Provider Engine'
$dnsLabel.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$dnsLabel.Location = New-Object System.Drawing.Point(15, 15)
$dnsLabel.Size = New-Object System.Drawing.Size(320, 25)
$dnsLabel.ForeColor = [System.Drawing.Color]::LightSalmon
$rightPanel.Controls.Add($dnsLabel)

$chkDnsMode = New-Object System.Windows.Forms.CheckBox
$chkDnsMode.Text = 'Enforce Secure DoH Providers'
$chkDnsMode.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
$chkDnsMode.Location = New-Object System.Drawing.Point(20, 55)
$chkDnsMode.Size = New-Object System.Drawing.Size(310, 22)
$chkDnsMode.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$chkDnsMode.ForeColor = [System.Drawing.Color]::Gainsboro
$rightPanel.Controls.Add($chkDnsMode)

$dnsComboLabel = New-Object System.Windows.Forms.Label
$dnsComboLabel.Text = 'Select DNS Template Provider:'
$dnsComboLabel.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$dnsComboLabel.Location = New-Object System.Drawing.Point(20, 95)
$dnsComboLabel.Size = New-Object System.Drawing.Size(300, 20)
$dnsComboLabel.ForeColor = [System.Drawing.Color]::DarkGray
$rightPanel.Controls.Add($dnsComboLabel)

$dnsComboBox = New-Object System.Windows.Forms.ComboBox
$dnsComboBox.Location = New-Object System.Drawing.Point(20, 120)
$dnsComboBox.Size = New-Object System.Drawing.Size(300, 25)
$dnsComboBox.BackColor = [System.Drawing.Color]::FromArgb(255, 45, 45, 45)
$dnsComboBox.ForeColor = [System.Drawing.Color]::White
$dnsComboBox.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$dnsComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

$dnsProviders = [ordered]@{ 
   'Cloudflare (1.1.1.1)' = 'https://chrome.cloudflare-dns.com/dns-query'
   'Google Public DNS'    = 'https://dns.google/dns-query{?dns}'
   'AdGuard (Ads Block)'  = 'https://dns.adguard.com/dns-query'
   'Quad9 Malware Protect'= 'https://dns.quad9.net/dns-query'
}

foreach ($p in $dnsProviders.Keys) { [void]$dnsComboBox.Items.Add($p) }
$dnsComboBox.SelectedIndex = 0
$rightPanel.Controls.Add($dnsComboBox)

# --- ACTION BUTTON ---
$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = 'Apply Selection to Registry'
$btnApply.Size = New-Object System.Drawing.Size(220, 40)
$btnApply.Location = New-Object System.Drawing.Point(20, 675)
$btnApply.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnApply.BackColor = [System.Drawing.Color]::FromArgb(255, 45, 45, 45)
$btnApply.ForeColor = [System.Drawing.Color]::LightSalmon
$btnApply.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
$btnApply.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnApply.Add_Click({
   try {
       $logBox.Text += " [PROCESS] Initializing Registry Commit Engine...`r`n"
       $reportPath = "$env:USERPROFILE\Desktop\Brave_Optimization_Report.txt"
       $reportContent = @('===================================================',
                          '        AMAR_AI SYSTEM ENGINE OPTIMIZATION REPORT  ',
                          "        Generated On: $((Get-Date).ToString())",
                          '===================================================',
                          '')
       
       foreach ($cb in $allFeatures) {
           if ($cb.Checked) {
               $item = $cb.Tag
               New-ItemProperty -Path $RegistryPath -Name $item.Key -Value $item.Value -PropertyType $item.Type -Force | Out-Null
               $successMsg = " [SUCCESS] Policy Set: $($item.Name)"
               $logBox.Text += $successMsg + "`r`n"
               $reportContent += $successMsg
           }
       }
       
       if ($chkDnsMode.Checked) {
           $selectedText = $dnsComboBox.SelectedItem.ToString()
           $templateUrl = $dnsProviders[$selectedText]
           New-ItemProperty -Path $RegistryPath -Name 'BuiltInDnsClientEnabled' -Value 1 -PropertyType 'DWord' -Force | Out-Null
           New-ItemProperty -Path $RegistryPath -Name 'DnsOverHttpsMode' -Value 'secure' -PropertyType 'String' -Force | Out-Null
           New-ItemProperty -Path $RegistryPath -Name 'DnsOverHttpsTemplates' -Value $templateUrl -PropertyType 'String' -Force | Out-Null
           
           $dnsLog = " [SUCCESS] Secure DNS Client Forced: $selectedText"
           $logBox.Text += $dnsLog + "`r`n"
           $reportContent += $dnsLog
       }
       
       $reportContent += ('', '===================================================')
       $reportContent | Out-File -FilePath $reportPath -Encoding utf8
       $logBox.Text += " [REPORT GENERATED] Saved to Desktop.`r`n"
       [System.Windows.Forms.MessageBox]::Show("Policies applied successfully!", 'Amar_ai Engine', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
   } catch {
       $logBox.Text += " [CRITICAL ERROR] $($_.Exception.Message)`r`n"
   }
})

$form.Controls.Add($btnApply)

# Safe Modal Activation
[System.Windows.Forms.Application]::Run($form)