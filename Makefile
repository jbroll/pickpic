
all: camera-sync pickpic

camera-sync : camera-sync.tcl
	unsource camera-sync.tcl > camera-sync
	chmod +x camera-sync

pickpic : pickpic.tcl
	unsource pickpic.tcl > pickpic
	chmod +x pickpic

install : camera-sync pickpic
	cp -p camera-sync $(HOME)/bin/camera-sync
	cp -p pickpic $(HOME)/bin/pickpic
