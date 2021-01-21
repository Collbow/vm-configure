# Copyright © 2020-2021 Collbow All Rights Reserved

cd "$PSScriptRoot"

Set-WinUserLanguageList -LanguageList ja-JP,en-US -Force

Set-WinUILanguageOverride -Language ja-JP
Set-Culture ja-JP