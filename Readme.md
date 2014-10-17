First Time Setup
================

Install/unzip ruby.
I downloaded from http://rubyinstaller.org/downloads - Ruby 2.1.3 (x64) 7-zip file and unziped it to c:\sassbuild\ruby

Install/unzip ruby devkit.
I downloaded from http://rubyinstaller.org/downloads - DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe and extracted using z-zip to C:\sassbuild\devkit

open a cmd in the devkit folder

run devkitvars.bat

cd to the ../ruby/bin folder

gem install io-console
gem install ocra
gem install wdm
gem install sass

copy thread.rb to bin
(I found this file on the internet, don't know what it does but it could be why you have to ctrl+c in a later step)


Building
========

gem update sass
ocra sass

This will hang so press ctrl+c and you will see the debug info, after a while it will say: Terminate batch job (Y/N)
Type N

in the bin folder will now be sass.exe
test with:
sass.exe --v 
You should get (or something similar to): Sass 3.4.6 (Selective Steve)