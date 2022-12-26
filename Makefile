DLL = app

ML_FLAG = /c /coff
LINK_FLAG = /subsystem:windows /Dll

$(DLL).dll: $(DLL).obj $(DLL).def
	Link  $(LINK_FLAG) /Def:$(DLL).def $(DLL).obj

.asm.obj:
	ml $(ML_FLAG) $<
.rc.res:
	rc $<

clean:
	del *.obj
	del *.exp

