OS := $(shell uname)

ifeq ($V, 1)
  Q =
  S =
else
  S ?= -s
  Q ?= @
endif

VM = qemu-system-i386

ifeq ($(OS), Darwin)
	AS      = i386-elf-as
	AFLAGS  = -g --32
	LD      = i386-elf-ld
	LDFLAGS = -m elf_i386
	CC      = i386-elf-gcc
	CFLAGS  = -gdwarf-2 -g3 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce #-Wall

	CPP     = i386-elf-cpp -nostdinc
	AR      = i386-elf-ar
	STRIP   = i386-elf-strip
	OBJCOPY = i386-elf-objcopy
endif

ifeq ($(OS), Linux)
	AS      = as
	AFLAGS  = -g --32
	LD      = ld
	LDFLAGS = -m elf_i386
	CC      = gcc
	CFLAGS  = -g -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce #-Wall

	CPP     = cpp -nostdinc
	AR      = ar
	STRIP   = strip
	OBJCOPY = objcopy
endif

test:
	echo $(OS)
	echo $(AS)

boot.o:boot.s
	$(AS) $(AFLAGS) -o boot.o boot.s

boot.img:boot.o
	$(LD) $(LDFLAGS) -o boot.img boot.o

qemu:boot.img
	qemu-system-i386 boot.img

clean:
	rm -rf *.o *.img *.bin

test.o:test.s
	$(AS) -o test.o test.s

test.bin:test.o
	$(LD) -Ttext 0x7c00 -o test.bin test.o

test.img:test.bin
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary test.bin test.img

test-qemu:test.img
	$(VM) test.img
