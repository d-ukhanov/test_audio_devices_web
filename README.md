## Features

TestAudioDevices is designed to test audio devices:
1. Displays a list of connected I/O devices;
2. Allows you to switch between I/O devices from the list of connected I/O devices;
3. Allows you to check the performance of audio devices using AudioElement from html, transferring sound from the input device to the output devices
4. Uses dart:html so only works on flutter web


## Additional information

The selection of input devices does not work in all browsers.
Browsers that do not support HTMLMediaElement.setSinkId() use the default speakers.
