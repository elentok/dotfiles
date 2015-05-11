Setting up Ubuntu 11.10 on Asus U35Jc
=====================================

There are two main problems to fix:
1. Suspend doesn't work out of the box
2. The nVidia Optimus card doesn't work out of the box

1. Fixing suspend
-----------------
- This is caused due to some usb buses that don't shutdown well
- Run "sudo fix-suspend.sh"
- Test the suspend feature to see if it works.

2. Fixing nVidia Optimus
------------------------
- Run "sudo fix-nvidia-optimus.sh" (this will install ironhide)
- Restart the computer
- Run ironhide-configuration
  (select the bottom configuration)
- Test the suspend feature to see if it works.
