cd "$PSScriptRoot"

Set-WinHomeLocation -GeoId 0x7A
Set-TimeZone -Id "Tokyo Standard Time"
Set-WinSystemLocale -SystemLocale ja-JP

Set-WinCultureFromLanguageListOptOut -OptOut $False
