fasm hos.asm hos.bin

qemu-system-i386 -drive format=raw,file=hos.bin -device isa-debug-exit,iobase=0xf4,iosize=0x04