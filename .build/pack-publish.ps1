Param(
    [Parameter(Mandatory=$true)]
	[string]$nuget,

    [Parameter(Mandatory=$true)]
	[string]$projectDir,

    [Parameter(Mandatory=$true)]
	[string]$projectName
)
Write-Host "Starting packages publisher for ${projectName}"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
$projectFullPath = "${projectDir}\${projectName}"
$nuspec = $projectFullPath.Replace("csproj", "nuspec")

# Validate.
if(!(Test-Path -Path $nuget)) {
    throw "Incorrect input parameters. Nuget doesn't exists by path '${nuget}'."
}
if(!(Test-Path -Path $projectFullPath)) {
    throw "Incorrect input parameters. Project file doesn't exists by path '${projectFullPath}'."
}
if(!(Test-Path -Path $nuspec)) {
    throw "Missed nuspec file from project dir. Need to create that file before publish. Instriction: https://docs.nuget.org/create/creating-and-publishing-a-package#from-a-project"
}

# Create Packages.
Write-Host "Create packages for deploy."
& $nuget pack $projectFullPath
if($LastExitCode -ne 0) {
	throw "Creating package failed."
}

# Prepare Packages List.
$packages = Get-ChildItem -Path ${currentDir}\*.nupkg | Foreach-Object {$_.FullName}

# Final Confirmation.
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Publish the packages."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Does not publish the packages."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
$result = $host.ui.PromptForChoice(
    "Publish packages. FINAL CONFIRMATION!", 
    "Packages are prepared and ready for publish. Do you want to upload the NuGet packages to the NuGet server?", 
    $options, 0)

if($result -eq 0) {
    # Clean-up.
    foreach($package in $packages) {
        Remove-Item -Path $package
    }
    return "Publish was aborted by user."
}

# Publish Packages to NuGet.
Write-Host "Publish Packages to NuGet."

foreach($package in $packages) {
    Write-Host "Publish ${package} to NuGet"
    & $nuget push $package -Source https://www.nuget.org/api/v2/package
    Remove-Item -Path $package
}
Write-Host "All packages was published."