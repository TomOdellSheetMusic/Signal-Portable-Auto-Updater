# Signal-Portable-Auto-Updater

### A simple batch script to automatically update Signal Portable.
Since the Signal Portable App from Portapps does not update correctly, here is an easy script for you to use.

## Requirements 
A <a href="https://github.com/portapps/signal-portable">Signal Portable</a> instance from PortApps. <br>

## IMPORTANT
The update button in the top left corner will NOT WORK. You need to run this script in order to update. This is a quirk of Signal Portable, not the script. <br>
The 7z.exe is just the normal, unaltered 7z.exe and dll that you would find in your personal installation. Feel free to download it yourself or check the checksum!

## Usage 

Simply put the batch folder into wherever you have your Signal Portable instance. This can also be done by extracting the zip from the Releases Tab. <br>
The batch folder needs to be on the same level as the app, data and log folders. The icon file is in case you want to make a shortcut to your start menu and want it to look nicer.

## Automatic Updates

If you want this to run automatically, simply use the task scheduler. I highly recommend using Version 1.2 or later of the script if you want to do that

### Folderstructure should look like this
<br>app
<br>
_batch_
<br>data
<br>log 
<br>changelog.md
<br>.
<br>.
<br>.

### Future Plans
-Make a Linux shell script
