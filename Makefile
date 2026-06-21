
all: camera-sync pickpic

camera-sync : camera-sync.tcl
	unsource camera-sync.tcl > $@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@

pickpic : pickpic.tcl
	unsource pickpic.tcl > $@.tmp
	chmod +x $@.tmp
	mv $@.tmp $@

install : camera-sync pickpic
	cp -p camera-sync $(HOME)/bin/camera-sync
	cp -p pickpic $(HOME)/bin/pickpic
