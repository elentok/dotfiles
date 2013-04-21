Mac OSX Tips
============

Keyboard
--------

* Use confirmation dialogs with the keyboard:
  
  * enter *Keyboard Settings -> Keyboard Shortcuts*
  * select *All controls*
  
* Control/Escape

  * In *System Preferences -> Keyboard -> Modifier Keys* set your *Caps Lock* to an extra *Control*
  
  * Using [KeyRemap4MacBook](http://pqrs.org/macosx/keyremap4macbook/):
    
    * Enable this:
    
      Control\_L to Control\_L
      (+ when you type Control\_L only, send Escape)

    * Now the Capslock key on the keyboard does the following:
    
      * If held down and pressed with another key, it acts like Control.
      * If pressed and released on its own, it acts like Escape.
  
    * Under "Key Repeat" set:
    
      * *[Key Overlaid Modifier] Timeout* = 300ms
      * *[Key Repeat] Initial Wait* = 300ms
      * *[Key Repeat] Wait* = 23ms

    * This tip was taken from [Steve losh](http://stevelosh.com/blog/2012/10/a-modern-space-cadet/#controlescape)
