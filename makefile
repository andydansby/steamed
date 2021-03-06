all: genesis.tzx

clean:
	del *.tzx
	del *.bin
	del *.sym
	del marker.tmp
#	del *~

genesis.tzx:  main.bin engine.bin sprites.bin ram3.bin ram4.bin ram0.bin ram6.bin rwks_logo.scr loading.scr
	buildtzx -l 3 -i template.txt -o genesis.tzx -n GENESiS

main.bin: main.c movement.o behavior.o engine.h movement.h behavior.h structs.h constants.h sprdefs.h
	zcc +zx -vn -O3 -zorg=24600 main.c movement.o behavior.o -lndos -o main.bin -m

movement.o: movement.c structs.h
	zcc +zx -vn -O3 -c movement.c -m

behavior.o: behavior.c structs.h
	zcc +zx -vn -O3 -c behavior.c -m

sprites.bin: sprites.asm
	pasmo sprites.asm sprites.bin sprites.sym

ram3.bin: ram3.asm background.bin gameover.bin ship_pieces.bin gameend.bin endattr.bin alien.bin alienattr.bin
	pasmo ram3.asm ram3.bin ram3.sym

engine.bin: engine.asm  input.asm rambanks.asm drawmap.asm drawsprite.asm create_shifted_tables.asm im2.asm starfield.asm
	pasmo engine.asm engine.bin engine.sym

background.bin: background.scr
	apack background.scr background.bin

gameover.bin: gameover.scr
	apack gameover.scr gameover.bin

ship_pieces.bin: ship_pieces.scr
	apack ship_pieces.scr ship_pieces.bin

gameend.bin: gameend.scr
	apack gameend.scr gameend.bin

endattr.bin: gameend.att
	apack gameend.att endattr.bin

alien.bin: alien.scr
	apack alien.scr alien.bin

alienattr.bin: alienattr.att
	apack alienattr.att alienattr.bin

ram4.bin: levels.asm level1.map level2.map level3.map level4.map level5.map level6.map level7.map level1_enemies.asm level2_enemies.asm level3_enemies.asm level4_enemies.asm level5_enemies.asm level6_enemies.asm level7_enemies.asm
	pasmo levels.asm ram4.bin levels.sym

ram0.bin: ProPlay37a.asm genesis_sfx.asm
	pasmo ProPlay37a.asm ram0.bin wyzplayer.sym


ram6.bin: menu.asm genesis_title.bin title_hiscores.bin credits_bkg.bin move.asm behav.asm maindefs.asm
	pasmo menu.asm menu.bin menu.sym
	pasmo move.asm move.bin move.sym
	pasmo behav.asm behav.bin behav.sym
	copy /b menu.bin+move.bin+behav.bin  ram6.bin

genesis_title.bin: genesis_title.scr
	apack genesis_title.scr genesis_title.bin

title_hiscores.bin: title_hiscores.scr
	apack title_hiscores.scr title_hiscores.bin

credits_bkg.bin: credits_bkg.scr
	apack credits_bkg.scr credits_bkg.bin
