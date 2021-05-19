
#### PickPic - A simple digital image curation web app.

PickPic allows a directory full of jpegs to be quickly triaged.  Set up
.pickpic in your home directory and run the script.  Images are read from the
'source' directory.  A page full of thumbnails is displayed in a browser.
Clicking on an image shows that image full frame.  Arrow keys can be used to
move forward and back in the sorted image list.  Pressing 's' saves an image to
the 'target' directory.  Beware pressing 'd' this deletes the image from
'source'.  This can be used to save most images in source, quickly deleting
junk images and moving nice images to target.

I keep my images on Microsoft OneDrive for easy cloud backup.  Most remain in
'Negatives', the catch all of 'undeveloped' images.  Nice pics goto 'Pictures'
for sharing with others.

#### .pickpic

    # Config for pickpic.tcl
    #
    set source /Users/john/OneDrive/Negatives
    set target /Users/john/OneDrive/Pictures

#### camera-sync - read images from a digital camera over USB

A companion script uses a patched [gphoto2](https://github.com/jbroll/gphoto2)
to unload my digital camera into the 'Negatives' directory before I use PickPic
to sort through them.

#### .camera-sync

    # Config for camera-sync.tcl
    #
    set start 8516
    set target /Users/john/OneDrive/Negatives