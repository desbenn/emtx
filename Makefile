.SILENT:
VFD		  = floppy.img
REDIRECT          = > /dev/null 2>&1

build:
	@echo "Running..."
	make clean
	make compile
	make link
	make image	
	@echo "Run Done!"

clean:
	@echo "Removing temporary files..."
	@rm -rf *.o		
	@echo "     Clean Done!"

compile:
	@echo "Compiling kernel..."
	@as86 -o ts.o ts.s
	@bcc  -c -ansi t.c
	@echo "     Compile Done!"

link:
	@echo "Building..."
	@ld86 -d -o mtx ts.o t.o mtxlib /usr/lib/bcc/libc.a
	@echo "     Build Done!"

image:
	@echo "Creating boot image..."
	@sudo mount -o loop -t ext2 $(VFD) /mnt 
	@sudo cp mtx /mnt/boot 
	@sudo umount /mnt 
	@echo "     Image Creation Done!"

boot:
	@echo "Booting Adassa..."
	@qemu-system-i386 -fda floppy.img -no-fd-bootchk
	@echo "     Boot Done!"


