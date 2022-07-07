# HAGIWO VCO Eurorack module (PCB edition)

This repo contains a Surface-Mount PCB layout for three modules by [hagiwo](https://www.youtube.com/channel/UCxErrnnVNEAAXPZvQFwobQw) remixed by [luislutz](https://github.com/luislutz/Arduino-VDCO) into a single Eurorack module, that design was iterated by [pansapiens](https://github.com/pansapiens/HAGIWO-Arduino-VDCO), and this repo is all of those things converted to a surface-mount PCB by Crows Electromusic.

This oscillator module is based on Arduino Nano and the Mozzi library.

The module has three modes - Chord generator, Additive synth mode and FM synth mode.

While most of the components are surface mount, some effort has been taken to make it hand-solderable.

## Original work by hagiwo:

- Additive VCO https://note.com/solder_state/n/n30b3a8737b1e
- FM VCO https://note.com/solder_state/n/n88317851a4c7
- Chord VCO https://note.com/solder_state/n/n681d2e07e324
- Check out all hagiwo's videos on youtube. A huge inspiration.

## Modifications by luislutz:

- Combine hagiwo's Additive, FM, and Chord modules into a single module.
- Add CV inputs for parameters 1 and 2.
- Add a VCA gain CV input normalized to 5V, with digital clipping if gain cv is over 5V
- The Sketch uses about 95% of the Memory on an Arduino Nano

### Modifications by pansapiens:

- uses single 5.1V Zener diodes rather than Schottky diodes for over-voltage protection.
- uses a single RGB LED rather than three LEDs.
- uses a momentary button for mode switching (with hardware debouncing)
- make the gain knob accessible on the front panel instead of as a trimpot
- some hacks to use more common resistor values (e.g. 2x1M instead of 1x500k)
- added diodes near the power input for over voltage protection

### Modifications by Crows Electromusic

- [x] convert it to a SMD PCB design
- [x] switch back to three LEDs
- [x] switch gain knob back to a trimpot (but make it front-panel accessible via a pinhole) 
- [ ] PCB based panel
- [ ] ?? 

## Build notes

NOTE: the crows version has not been made or validated yet. Build at your own risk.

# Code

## Compiling

To compile the code you need to install the [Mozzi](https://github.com/sensorium/Mozzi) Arduino library and ensure that `#define AUDIO_MODE HIFI` is set in `mozzi_config.h`.

## Flashing

To flash a cheapo Arduino Nano clone, you may need to select "ATmega328P (Old Bootloader)" under Tools->Processor in the Arduino IDE.

