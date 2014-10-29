if(!(Test-Path -Path Ruby.7z )){
    Invoke-WebRequest http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.3-i386-mingw32.7z?direct -OutFile Ruby.7z
}

if(!(Test-Path -Path Ruby )){
    .\7z x Ruby.7z
    Rename-Item ruby-2.1.3-i386-mingw32 Ruby
    Copy-Item thread.rb .\Ruby\bin
}

if(!(Test-Path -Path DevKit.exe )){
    Invoke-WebRequest http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe -OutFile DevKit.exe
}

if(!(Test-Path -Path DevKit )){
    .\7z x devkit.exe -oDevKit
    .\DevKit\devkitvars.ps1

    .\Ruby\bin\gem install "io-console"
    .\Ruby\bin\gem install json
}

cd .\Ruby\bin

$OutputVariable = (.\gem list ocra -i) | Out-String
if($OutputVariable.StartsWith("f")) {
    .\gem install ocra
}

$OutputVariable = (.\gem list sass -i) | Out-String
if($OutputVariable.StartsWith("f")) {
    .\gem install sass
}

$OutputVariable = (.\gem list webrick -i) | Out-String
if($OutputVariable.StartsWith("f")) {
    .\gem install webrick
}

.\gem update sass

.\ocra ..\..\sass.rb --output ..\..\sass.exe

cd ..\..