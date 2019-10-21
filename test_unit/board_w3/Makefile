all:
	rm -rf boot/ebin/* boot/src/*~;
	erlc -o boot/ebin boot/src/*.erl;
	erl -pa boot/ebin -s boot_board start -sname board_w3
