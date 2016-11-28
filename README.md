# PillarCon NES Game

### Build Steps:

Download or clone the nesasm for mac repository:
```
https://github.com/cesarparent/NESAsm-3.1-Mac
```
Run `make` on the nesasm repository. This will create a `nesasm` file inside the build/ directory. Add this file to your path.

From within the PillarCon repository, run the following command:

```
nesasm pillarcon.asm
```

This will generate the pillarcon.nes file to be played on an NES emulator.
