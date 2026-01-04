\# hOS

Минималистичная ОС на FASM.



\## Команды

\- `exit` — выключение системы.

\- Любой текст — ввод с поддержкой Backspace.



\## Как собрать

1\. Установите FASM.

2\. Запустите: `fasm hos.asm hos.bin`

3\. Запустите в QEMU: `qemu-system-i386 -drive format=raw,file=hos.bin`

