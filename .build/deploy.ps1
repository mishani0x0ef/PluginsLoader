Param(
	[string]$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
)

if([string]::IsNullOrEmpty($msbuild) -or !(Test-Path -Path $msbuild)) {
    Write-Error "MSBuild not found by path '${msbuild}'."
    return
}

# Confirmation.
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Publish the packages."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Does not publish the packages."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
$result = $host.ui.PromptForChoice("Publish packages", "Do you want to upload the NuGet packages to the NuGet server?", $options, 0)

if($result -eq 0) {
    return "Publish was aborted by user."
}

Write-Host "Start Publish process."

$baseDir = (Get-Item -Path "..\" -Verbose).FullName
$projDir = "${baseDir}\src"
$projFileName = "PluginsLoader.csproj"
$nuget ="${baseDir}\.nuget\nuget.exe"

try {
    # Build.
    Write-Host "Start build process."
    & $msbuild "build.proj" "/p:Configuration=Release"
    if($LastExitCode -ne 0) {
        throw "Build failed."
    }

    # Publish
    Write-Host "Run package publisher."
    & "./pack-publish.ps1" $nuget $projDir $projFileName
}
catch [System.Exception] {
    Write-Error "Publish process was terminated because of errors."
}
