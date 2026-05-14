$target = "d:\Delivery\WebSite\Admin\Pages\Menuitems.aspx"
$temp = "d:\Delivery\WebSite\Admin\Pages\temp_script.js"
$lines = Get-Content $target
$tempLines = Get-Content $temp
$newLines = @()
$newLines += $lines[0..826]
$newLines += $tempLines
$newLines += $lines[849..($lines.Length-1)]
$newLines | Set-Content $target -Encoding UTF8
