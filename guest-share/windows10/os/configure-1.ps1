cd "$PSScriptRoot"

Set-WinUserLanguageList -LanguageList ja-JP,en-US -Force

Set-WinUILanguageOverride -Language ja-JP
Set-Culture ja-JP