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

### Additional Resources:

Here is a great tutorial for learning the basics of NES development:
```
http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=7155
```

Here is a link to the 6502 instruction set:
```
http://www.e-tradition.net/bytes/6502/6502_instruction_set.html
```

Here is some information on the nesasm assembler, including stuff about macros and directives:
```
http://www.nespowerpak.com/nesasm/usage.txt
```
