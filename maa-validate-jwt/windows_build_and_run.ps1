$curdir = Get-Location
$out = ".\out"
If((Test-Path $out))
{
    Remove-Item $out -Force -Recurse
}
New-Item -ItemType Directory -Force -Path $out
$Env:LOCAL_ROOT=(Split-Path $(Get-Location) -Parent)

cd $out 

cmake ..\

$msbuildpath=$Args[0]

If($msbuildpath -eq $null) {
    $msbuildpath = ";C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin"
}

echo "Temporary adding '$msbuildpath' to the PATH"

Set-Item -Path Env:Path -Value ($Env:Path + $msbuildpath)
msbuild maa-validate-jwt.sln
cd .\Debug
.\maa-validate-jwt.exe
cd $curdir
