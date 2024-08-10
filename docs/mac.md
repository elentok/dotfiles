# Mac OSX Tips

## Keyboard

- Use confirmation dialogs with the keyboard:

  - enter _Keyboard Settings -> Keyboard Shortcuts_
  - select _All controls_

- Control/Escape

  - In _System Preferences -> Keyboard -> Modifier Keys_ set your _Caps Lock_ to an extra _Control_
  - Using [KeyRemap4MacBook](http://pqrs.org/macosx/keyremap4macbook/):

    - Enable this:

      Control_L to Control_L (+ when you type Control_L only, send Escape)

    - Now the Capslock key on the keyboard does the following:

      - If held down and pressed with another key, it acts like Control.
      - If pressed and released on its own, it acts like Escape.

    - Under "Key Repeat" set:

      - _[Key Overlaid Modifier] Timeout_ = 300ms
      - _[Key Repeat] Initial Wait_ = 300ms
      - _[Key Repeat] Wait_ = 23ms

    - This tip was taken from
      [Steve losh](http://stevelosh.com/blog/2012/10/a-modern-space-cadet/#controlescape)
