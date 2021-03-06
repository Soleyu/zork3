

	.FUNCT	V-VERBOSE
	SET	'VERBOSE,TRUE-VALUE
	SET	'SUPER-BRIEF,FALSE-VALUE
	PRINTR	"Maximum verbosity."


	.FUNCT	V-BRIEF
	SET	'VERBOSE,FALSE-VALUE
	SET	'SUPER-BRIEF,FALSE-VALUE
	PRINTR	"Brief descriptions."


	.FUNCT	V-SUPER-BRIEF
	SET	'SUPER-BRIEF,TRUE-VALUE
	PRINTR	"Super-brief descriptions."


	.FUNCT	V-LOOK
	CALL	DESCRIBE-ROOM,TRUE-VALUE
	ZERO?	STACK /FALSE
	CALL	DESCRIBE-OBJECTS,TRUE-VALUE
	RSTACK	


	.FUNCT	V-FIRST-LOOK
	CALL	DESCRIBE-ROOM
	ZERO?	STACK /FALSE
	ZERO?	SUPER-BRIEF \FALSE
	CALL	DESCRIBE-OBJECTS
	RSTACK	


	.FUNCT	V-EXAMINE
	GETP	PRSO,P?TEXT
	ZERO?	STACK /?ELS5
	GETP	PRSO,P?TEXT
	PRINT	STACK
	CRLF	
	RTRUE	
?ELS5:	FSET?	PRSO,CONTBIT /?THN10
	FSET?	PRSO,DOORBIT \?ELS9
?THN10:	CALL	V-LOOK-INSIDE
	RSTACK	
?ELS9:	PRINTI	"I see nothing special about the "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	DESCRIBE-ROOM,LOOK?=0,V?,STR,AV
	ZERO?	LOOK? /?ORP4
	PUSH	LOOK?
	JUMP	?THN1
?ORP4:	PUSH	VERBOSE
?THN1:	POP	'V?
	ZERO?	LIT \?CND5
	PRINTI	"It is pitch black."
	ZERO?	SPRAYED? \?CND10
	PRINTI	" You are likely to be eaten by a grue."
?CND10:	CRLF	
	EQUAL?	HERE,DARK-2 \?CND15
	PRINTI	"The ground continues to slope upwards away from the lake. You can barely  detect a dim light from the east."
	CRLF	
	RETURN	FALSE-VALUE
?CND15:	RETURN	FALSE-VALUE
?CND5:	FSET?	HERE,TOUCHBIT /?CND20
	FSET	HERE,TOUCHBIT
	SET	'V?,TRUE-VALUE
?CND20:	IN?	HERE,ROOMS \?CND23
	PRINTD	HERE
	CRLF	
?CND23:	ZERO?	LOOK? \?THN31
	ZERO?	SUPER-BRIEF \TRUE
?THN31:	LOC	WINNER >AV
	FSET?	AV,VEHBIT \?CND33
	PRINTI	"(You are in the "
	PRINTD	AV
	PRINTI	".)"
	CRLF	
?CND33:	ZERO?	V? /?ELS40
	GETP	HERE,P?ACTION
	CALL	STACK,M-LOOK
	ZERO?	STACK \TRUE
?ELS40:	ZERO?	V? /?ELS44
	GETP	HERE,P?LDESC >STR
	ZERO?	STR /?ELS44
	PRINT	STR
	CRLF	
	JUMP	?CND38
?ELS44:	GETP	HERE,P?ACTION
	CALL	STACK,M-FLASH
?CND38:	EQUAL?	HERE,AV /TRUE
	FSET?	AV,VEHBIT \TRUE
	GETP	AV,P?ACTION
	CALL	STACK,M-LOOK
	RTRUE	


	.FUNCT	DESCRIBE-OBJECTS,V?=0
	ZERO?	LIT /?ELS5
	FIRST?	HERE \FALSE
	ZERO?	V? /?ORP15
	PUSH	V?
	JUMP	?THN12
?ORP15:	PUSH	VERBOSE
?THN12:	POP	'V?
	CALL	PRINT-CONT,HERE,V?,-1
	RSTACK	
?ELS5:	PRINTR	"I can't see anything in the dark."


	.FUNCT	DESCRIBE-OBJECT,OBJ,V?,LEVEL,STR=0,AV
	SET	'DESC-OBJECT,OBJ
	ZERO?	LEVEL \?ELS3
	GETP	OBJ,P?DESCFCN
	CALL	STACK,M-OBJDESC
	ZERO?	STACK \TRUE
?ELS3:	ZERO?	LEVEL \?ELS7
	FSET?	OBJ,TOUCHBIT /?ELS13
	GETP	OBJ,P?FDESC >STR
	ZERO?	STR \?THN10
?ELS13:	GETP	OBJ,P?LDESC >STR
	ZERO?	STR /?ELS7
?THN10:	PRINT	STR
	JUMP	?CND1
?ELS7:	ZERO?	LEVEL \?ELS17
	PRINTI	"There is a "
	PRINTD	OBJ
	PRINTI	" here."
	JUMP	?CND1
?ELS17:	GET	INDENTS,LEVEL
	PRINT	STACK
	PRINTI	"A "
	PRINTD	OBJ
	FSET?	OBJ,WEARBIT \?CND1
	PRINTI	" (being worn)"
?CND1:	ZERO?	LEVEL \?CND31
	LOC	WINNER >AV
	ZERO?	AV /?CND31
	FSET?	AV,VEHBIT \?CND31
	PRINTI	" (outside the "
	PRINTD	AV
	PRINTI	")"
?CND31:	CRLF	
	CALL	SEE-INSIDE?,OBJ
	ZERO?	STACK /FALSE
	FIRST?	OBJ \FALSE
	CALL	PRINT-CONT,OBJ,V?,LEVEL
	RSTACK	


	.FUNCT	PRINT-CONT,OBJ,V?=0,LEVEL=0,Y,1ST?,AV,STR,PV?=0,INV?=0
	FIRST?	OBJ >Y \TRUE
	LOC	WINNER >AV
	ZERO?	AV /?ELS6
	FSET?	AV,VEHBIT \?ELS6
	JUMP	?CND4
?ELS6:	SET	'AV,FALSE-VALUE
?CND4:	SET	'1ST?,TRUE-VALUE
	LOC	OBJ
	EQUAL?	WINNER,OBJ,STACK \?ELS13
	SET	'INV?,TRUE-VALUE
	JUMP	?CND11
?ELS13:	
?PRG16:	ZERO?	Y \?ELS20
	JUMP	?CND11
?ELS20:	EQUAL?	Y,AV \?ELS22
	SET	'PV?,TRUE-VALUE
	JUMP	?CND18
?ELS22:	EQUAL?	Y,WINNER \?ELS24
	JUMP	?CND18
?ELS24:	FSET?	Y,INVISIBLE /?CND18
	FSET?	Y,TOUCHBIT /?CND18
	GETP	Y,P?FDESC >STR
	ZERO?	STR /?CND18
	FSET?	Y,NDESCBIT /?CND29
	PRINT	STR
	CRLF	
?CND29:	CALL	SEE-INSIDE?,Y
	ZERO?	STACK /?CND18
	LOC	Y
	GETP	STACK,P?DESCFCN
	ZERO?	STACK \?CND18
	FIRST?	Y \?CND18
	CALL	PRINT-CONT,Y,V?,0
?CND18:	NEXT?	Y >Y /?KLU76
?KLU76:	JUMP	?PRG16
?CND11:	FIRST?	OBJ >Y /?KLU77
?KLU77:	
?PRG39:	ZERO?	Y \?ELS43
	ZERO?	PV? /?CND44
	ZERO?	AV /?CND44
	FIRST?	AV \?CND44
	CALL	PRINT-CONT,AV,V?,LEVEL
?CND44:	ZERO?	1ST? \?PRD49
	PUSH	1
	RETURN	STACK
?PRD49:	PUSH	0
	RETURN	STACK
?ELS43:	EQUAL?	Y,AV,ADVENTURER \?ELS52
	JUMP	?CND41
?ELS52:	FSET?	Y,INVISIBLE /?CND41
	ZERO?	INV? \?THN57
	FSET?	Y,TOUCHBIT /?THN57
	GETP	Y,P?FDESC
	ZERO?	STACK \?CND41
?THN57:	FSET?	Y,NDESCBIT /?ELS61
	ZERO?	1ST? /?CND62
	CALL	FIRSTER,OBJ,LEVEL
	ZERO?	STACK /?CND66
	LESS?	LEVEL,0 \?CND66
	SET	'LEVEL,0
?CND66:	INC	'LEVEL
	SET	'1ST?,FALSE-VALUE
?CND62:	CALL	DESCRIBE-OBJECT,Y,V?,LEVEL
	JUMP	?CND41
?ELS61:	FIRST?	Y \?CND41
	CALL	SEE-INSIDE?,Y
	ZERO?	STACK /?CND41
	CALL	PRINT-CONT,Y,V?,LEVEL
?CND41:	NEXT?	Y >Y /?KLU78
?KLU78:	JUMP	?PRG39


	.FUNCT	FIRSTER,OBJ,LEVEL
	EQUAL?	OBJ,WINNER \?ELS5
	PRINTR	"You are carrying:"
?ELS5:	IN?	OBJ,ROOMS /FALSE
	GRTR?	LEVEL,0 \?CND10
	GET	INDENTS,LEVEL
	PRINT	STACK
?CND10:	FSET?	OBJ,SURFACEBIT \?ELS19
	PRINTI	"Sitting on the "
	PRINTD	OBJ
	PRINTR	" is:"
?ELS19:	PRINTI	"The "
	PRINTD	OBJ
	PRINTR	" contains:"


	.FUNCT	V-SCORE,ASK?=1
	PRINTI	"Your potential is "
	PRINTN	SCORE
	PRINTI	" of a possible "
	PRINTN	SCORE-MAX
	PRINTI	", in "
	PRINTN	MOVES
	EQUAL?	MOVES,1 \?ELS9
	PRINTI	" move."
	JUMP	?CND7
?ELS9:	PRINTI	" moves."
?CND7:	CRLF	
	RETURN	SCORE


	.FUNCT	FINISH
	CALL	V-SCORE
	QUIT	
	RTRUE	


	.FUNCT	V-QUIT,ASK?=1,SCOR
	CALL	V-SCORE
	ZERO?	ASK? /?ELS9
	PRINTI	"Do you wish to leave the game? (Y is affirmative): "
	CALL	YES?
	ZERO?	STACK \?THN6
?ELS9:	ZERO?	ASK? \?ELS5
?THN6:	QUIT	
	RTRUE	
?ELS5:	PRINTR	"Ok."


	.FUNCT	YES?
	PRINTI	">"
	READ	P-INBUF,P-LEXV
	GET	P-LEXV,1
	EQUAL?	STACK,W?YES,W?Y \FALSE
	RTRUE	


	.FUNCT	V-VERSION,CNT=17
	PRINTI	"ZORK III: The Dungeon Master
Copyright 1982 by Infocom, Inc. All rights reserved.
ZORK is a trademark of Infocom, Inc.
Release "
	GET	0,1
	BAND	STACK,2047
	PRINTN	STACK
	PRINTI	" / Serial number "
?PRG5:	IGRTR?	'CNT,23 \?ELS9
	JUMP	?REP6
?ELS9:	GETB	0,CNT
	PRINTC	STACK
	JUMP	?PRG5
?REP6:	CRLF	
	RTRUE	


	.FUNCT	IN-HERE?,OBJ
	IN?	OBJ,HERE /TRUE
	CALL	GLOBAL-IN?,OBJ,HERE
	RSTACK	


	.FUNCT	V-AGAIN,OBJ
	EQUAL?	L-PRSA,V?WALK \?ELS5
	CALL	PERFORM,L-PRSA,L-PRSO
	RSTACK	
?ELS5:	ZERO?	L-PRSO /?ELS12
	LOC	L-PRSO
	ZERO?	STACK \?ELS12
	PUSH	L-PRSO
	JUMP	?CND8
?ELS12:	ZERO?	L-PRSI /?PRD10
	LOC	L-PRSO
	ZERO?	STACK \?PRD10
	PUSH	L-PRSI
	JUMP	?CND8
?PRD10:	PUSH	0
?CND8:	SET	'OBJ,STACK
	ZERO?	OBJ /?ELS23
	PRINTI	"I can't see the "
	PRINTD	OBJ
	PRINTI	" anymore."
	CRLF	
	RETURN	2
?ELS23:	CALL	PERFORM,L-PRSA,L-PRSO,L-PRSI
	RSTACK	


	.FUNCT	JIGS-UP,DESC,PLAYER?=0
	SET	'SWORD-STATE,0
	SET	'P-STRENGTH,5
	SET	'S-STRENGTH,5
	PRINT	DESC
	CRLF	
	EQUAL?	YEAR,YEAR-PRESENT /?CND3
	QUIT	
?CND3:	EQUAL?	ADVENTURER,WINNER /?CND6
	PRINTI	" 
   ****  The "
	PRINTD	WINNER
	PRINTI	" has died  **** 

"
	REMOVE	WINNER
	SET	'WINNER,ADVENTURER
	LOC	WINNER >HERE
	RETURN	2
?CND6:	PRINTI	" 
   ****  You have died  **** 

"
	IGRTR?	'DEATHS,3 \?ELS17
	PRINTI	"You feel yourself disembodied in a deep blackness. A voice from the void speaks:  ""I have waited a long age for you, my friend, but perhaps it has been another that I have been seeking. Good night, oh worthy adventurer!"" It is the last you hear."
	CRLF	
	QUIT	
	JUMP	?CND15
?ELS17:	PRINTI	"You find yourself deep within the earth in a barren prison cell. Outside the iron-barred window, you can see a great, fiery pit. Flames leap up and very nearly sear your flesh. After a while, footfalls can be heard in the distance, then closer and closer.... The door swings open, and in walks an old man.

He is dressed simply in a hood and cloak, wearing a few simple jewels, carrying something under one arm, and leaning on a wooden staff. A single key, as if to a massive prison cell, hangs from his belt.

He raises the staff toward you and you hear him speak, as if in a dream: ""I await you, though your journey be long and full of peril. Go then, and let me not wait long!"" You feel some great power well up inside you and you fall to the floor. The next moment, you are awakening, as if from a deep slumber."
	CRLF	
?CND15:	MOVE	CURRENT-LAMP,ZORK2-STAIR
	IN?	KEY,WINNER \?CND24
	EQUAL?	HERE,DARK-1,DARK-2,KEY-ROOM /?THN29
	EQUAL?	HERE,AQ-1,AQ-2 \?CND24
?THN29:	MOVE	KEY,KEY-ROOM
?CND24:	CRLF	
	CALL	GOTO,ZORK2-STAIR
	SET	'P-CONT,FALSE-VALUE
	CALL	RANDOMIZE-OBJECTS
	CALL	KILL-INTERRUPTS
	RETURN	2


	.FUNCT	RANDOMIZE-OBJECTS,R=0,F,N,L
	FIRST?	WINNER >N /?KLU6
?KLU6:	
?PRG1:	SET	'F,N
	ZERO?	F /TRUE
	NEXT?	F >N /?KLU7
?KLU7:	CALL	PICK-ONE,DEAD-OBJ-LOCS
	MOVE	F,STACK
	JUMP	?PRG1


	.FUNCT	KILL-INTERRUPTS
	CALL	INT,I-MAN-LEAVES
	PUT	STACK,0,0
	CALL	INT,I-MAN-RETURNS
	PUT	STACK,0,0
	CALL	INT,I-VIEW-SNAP
	PUT	STACK,0,0
	CALL	INT,I-FOLIN
	PUT	STACK,0,0
	RTRUE	


	.FUNCT	V-RESTORE
	RESTORE	 \?ELS5
	PRINTI	"Ok."
	CRLF	
	CALL	V-FIRST-LOOK
	RSTACK	
?ELS5:	PRINTR	"Failed."


	.FUNCT	V-SAVE
	SAVE	 \?ELS5
	PRINTR	"Ok."
?ELS5:	PRINTR	"Failed."


	.FUNCT	V-RESTART
	CALL	V-SCORE,TRUE-VALUE
	PRINTI	"Do you wish to restart? (Y is affirmative): "
	CALL	YES?
	ZERO?	STACK /FALSE
	PRINTI	"Restarting."
	CRLF	
	RESTART	
	PRINTR	"Failed."


	.FUNCT	V-WALK-AROUND
	PRINTR	"Use directions for movement here."


	.FUNCT	V-LAUNCH
	FSET?	PRSO,VEHBIT \?ELS5
	PRINTR	"You can't launch that by saying ""launch""!"
?ELS5:	PRINTR	"How in blazes does one launch that?"


	.FUNCT	GO-NEXT,TBL,VAL
	CALL	LKP,HERE,TBL >VAL
	ZERO?	VAL /FALSE
	CALL	GOTO,VAL
	RSTACK	


	.FUNCT	LKP,ITM,TBL,CNT=0,LEN
	GET	TBL,0 >LEN
?PRG1:	IGRTR?	'CNT,LEN /FALSE
	GET	TBL,CNT
	EQUAL?	STACK,ITM \?PRG1
	EQUAL?	CNT,LEN /FALSE
	ADD	CNT,1
	GET	TBL,STACK
	RETURN	STACK


	.FUNCT	V-WALK,PT,PTS,STR,OBJ,RM
	ZERO?	P-WALK-DIR \?ELS5
	CALL	PERFORM,V?WALK-TO,PRSO
	RTRUE	
?ELS5:	GETPT	HERE,PRSO >PT
	ZERO?	PT /?ELS7
	PTSIZE	PT >PTS
	EQUAL?	PTS,UEXIT \?ELS12
	GETB	PT,REXIT
	CALL	GOTO,STACK
	RSTACK	
?ELS12:	EQUAL?	PTS,NEXIT \?ELS14
	GET	PT,NEXITSTR
	PRINT	STACK
	CRLF	
	RETURN	2
?ELS14:	EQUAL?	PTS,FEXIT \?ELS20
	GET	PT,FEXITFCN
	CALL	STACK >RM
	ZERO?	RM /?ELS25
	CALL	GOTO,RM
	RSTACK	
?ELS25:	EQUAL?	HERE,CP \?ELS27
	ZERO?	CP-MOVED \TRUE
?ELS27:	RETURN	2
?ELS20:	EQUAL?	PTS,CEXIT \?ELS35
	GETB	PT,CEXITFLAG
	VALUE	STACK
	ZERO?	STACK /?ELS40
	GETB	PT,REXIT
	CALL	GOTO,STACK
	RSTACK	
?ELS40:	GET	PT,CEXITSTR >STR
	ZERO?	STR /?ELS42
	PRINT	STR
	CRLF	
	RETURN	2
?ELS42:	PRINTI	"You can't go that way."
	CRLF	
	RETURN	2
?ELS35:	EQUAL?	PTS,DEXIT \FALSE
	GETB	PT,DEXITOBJ >OBJ
	FSET?	OBJ,OPENBIT \?ELS59
	GETB	PT,REXIT
	CALL	GOTO,STACK
	RSTACK	
?ELS59:	GET	PT,DEXITSTR >STR
	ZERO?	STR /?ELS61
	PRINT	STR
	CRLF	
	RETURN	2
?ELS61:	PRINTI	"The "
	PRINTD	OBJ
	PRINTI	" is closed."
	CRLF	
	CALL	THIS-IS-IT,OBJ
	RETURN	2
?ELS7:	ZERO?	LIT \?ELS73
	RANDOM	100
	GRTR?	90,STACK \?ELS73
	ZERO?	SPRAYED? /?ELS80
	PRINTI	"There are odd noises in the darkness, and there is no exit in that direction."
	CRLF	
	RETURN	2
?ELS80:	EQUAL?	HERE,DARK-1,DARK-2 \?ELS87
	CALL	JIGS-UP,STR?22
	RSTACK	
?ELS87:	CALL	JIGS-UP,STR?23
	RSTACK	
?ELS73:	PRINTI	"You can't go that way."
	CRLF	
	RETURN	2


	.FUNCT	THIS-IS-IT,OBJ
	SET	'P-IT-OBJECT,OBJ
	SET	'P-IT-LOC,HERE
	RETURN	P-IT-LOC


	.FUNCT	V-INVENTORY
	FIRST?	WINNER \?ELS5
	CALL	PRINT-CONT,WINNER
	RSTACK	
?ELS5:	PRINTR	"You are empty handed."


	.FUNCT	PRE-TAKE
	IN?	PRSO,WINNER \?ELS5
	FSET?	PRSO,WEARBIT \?ELS10
	PRINTR	"You are already wearing it."
?ELS10:	PRINTR	"You already have it."
?ELS5:	LOC	PRSO
	FSET?	STACK,CONTBIT \?ELS18
	LOC	PRSO
	FSET?	STACK,OPENBIT /?ELS18
	PRINTR	"You can't reach that."
?ELS18:	ZERO?	PRSI /?ELS24
	LOC	PRSO
	EQUAL?	PRSI,STACK /?ELS30
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" isn't in the "
	PRINTD	PRSI
	PRINTR	"."
?ELS30:	SET	'PRSI,FALSE-VALUE
	RFALSE	
?ELS24:	LOC	WINNER
	EQUAL?	PRSO,STACK \FALSE
	PRINTR	"You are in it, loser!"


	.FUNCT	V-TAKE
	CALL	ITAKE
	EQUAL?	STACK,TRUE-VALUE \FALSE
	FSET?	PRSO,WEARBIT \?ELS10
	PRINTI	"You are now wearing the "
	PRINTD	PRSO
	PRINTR	"."
?ELS10:	PRINTR	"Taken."


	.FUNCT	ITAKE,VB=1,CNT,OBJ,?TMP1
	FSET?	PRSO,TAKEBIT /?ELS5
	ZERO?	VB /FALSE
	CALL	PICK-ONE,YUKS
	PRINT	STACK
	CRLF	
	RFALSE	
?ELS5:	LOC	PRSO
	IN?	STACK,WINNER /?ELS13
	CALL	WEIGHT,PRSO >?TMP1
	CALL	WEIGHT,WINNER
	ADD	?TMP1,STACK
	GRTR?	STACK,LOAD-ALLOWED \?ELS13
	ZERO?	VB /?CND16
	PRINTI	"Your load is too heavy"
	LESS?	LOAD-ALLOWED,LOAD-MAX \?ELS24
	PRINTI	", especially in light of your condition."
	JUMP	?CND22
?ELS24:	PRINTI	"."
?CND22:	CRLF	
?CND16:	RETURN	2
?ELS13:	CALL	CCOUNT,WINNER >CNT
	GRTR?	CNT,FUMBLE-NUMBER \?ELS34
	MUL	CNT,FUMBLE-PROB >?TMP1
	RANDOM	100
	GRTR?	?TMP1,STACK \?ELS34
	FIRST?	WINNER >OBJ /?KLU48
?KLU48:	
?PRG37:	NEXT?	OBJ >OBJ /?KLU49
?KLU49:	FSET?	OBJ,WEARBIT /?PRG37
	PRINTI	"Oh, no. The "
	PRINTD	OBJ
	PRINTI	" slips from your arms while taking the "
	PRINTD	PRSO
	PRINTI	" and both tumble to the ground."
	CRLF	
	CALL	PERFORM,V?DROP,OBJ
	RETURN	2
?ELS34:	MOVE	PRSO,WINNER
	FSET	PRSO,TOUCHBIT
	RTRUE	


	.FUNCT	V-PUT-ON
	FSET?	PRSI,SURFACEBIT \?ELS5
	CALL	V-PUT
	RSTACK	
?ELS5:	PRINTI	"There's no good surface on the "
	PRINTD	PRSI
	PRINTR	"."


	.FUNCT	PRE-PUT
	EQUAL?	PRSO,SHORT-POLE /FALSE
	IN?	PRSO,GLOBAL-OBJECTS /?THN8
	FSET?	PRSO,TAKEBIT /FALSE
?THN8:	PRINTR	"Nice try."


	.FUNCT	V-PUT,?TMP1
	FSET?	PRSI,OPENBIT /?CND1
	FSET?	PRSI,DOORBIT /?THN6
	FSET?	PRSI,CONTBIT /?CND1
?THN6:	FSET?	PRSI,VEHBIT \?ELS3
	JUMP	?CND1
?ELS3:	PRINTR	"I can't do that."
?CND1:	FSET?	PRSI,OPENBIT /?ELS16
	PRINTI	"The "
	PRINTD	PRSI
	PRINTR	" isn't open."
?ELS16:	EQUAL?	PRSI,PRSO \?ELS20
	PRINTR	"How can you do that?"
?ELS20:	IN?	PRSO,PRSI \?ELS24
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is already in the "
	PRINTD	PRSI
	PRINTR	"."
?ELS24:	CALL	WEIGHT,PRSI >?TMP1
	CALL	WEIGHT,PRSO
	ADD	?TMP1,STACK >?TMP1
	GETP	PRSI,P?SIZE
	SUB	?TMP1,STACK >?TMP1
	GETP	PRSI,P?CAPACITY
	GRTR?	?TMP1,STACK \?ELS28
	PRINTR	"There's no room."
?ELS28:	CALL	HELD?,PRSO
	ZERO?	STACK \?ELS32
	CALL	ITAKE
	ZERO?	STACK /TRUE
?ELS32:	MOVE	PRSO,PRSI
	FSET	PRSO,TOUCHBIT
	PRINTR	"Done."


	.FUNCT	PRE-DROP
	LOC	WINNER
	EQUAL?	PRSO,STACK \FALSE
	CALL	PERFORM,V?DISEMBARK,PRSO
	RTRUE	


	.FUNCT	PRE-GIVE
	CALL	HELD?,PRSO
	ZERO?	STACK \FALSE
	PRINTR	"That's easy for you to say since you don't even have it."


	.FUNCT	PRE-SGIVE
	CALL	PERFORM,V?GIVE,PRSI,PRSO
	RTRUE	


	.FUNCT	HELD?,OBJ
	IN?	OBJ,WINNER /TRUE
	IN?	OBJ,ROOMS /FALSE
	IN?	OBJ,GLOBAL-OBJECTS /FALSE
	ZERO?	OBJ /FALSE
	LOC	OBJ
	CALL	HELD?,STACK
	RSTACK	


	.FUNCT	V-GIVE
	FSET?	PRSI,VICBIT /?ELS5
	PRINTI	"You can't give a "
	PRINTD	PRSO
	PRINTI	" to a "
	PRINTD	PRSI
	PRINTR	"!"
?ELS5:	PRINTI	"The "
	PRINTD	PRSI
	PRINTR	" refuses it politely."


	.FUNCT	V-SGIVE
	PRINTR	"FOOOO!!"


	.FUNCT	V-DROP
	CALL	IDROP
	ZERO?	STACK /FALSE
	PRINTR	"Dropped."


	.FUNCT	V-THROW
	CALL	IDROP
	ZERO?	STACK /FALSE
	PRINTR	"Thrown."


	.FUNCT	IDROP
	IN?	PRSO,WINNER /?ELS5
	LOC	PRSO
	IN?	STACK,WINNER /?ELS5
	PRINTI	"You're not carrying the "
	PRINTD	PRSO
	PRINTI	"."
	CRLF	
	RFALSE	
?ELS5:	IN?	PRSO,WINNER /?ELS11
	LOC	PRSO
	FSET?	STACK,OPENBIT /?ELS11
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is closed."
	CRLF	
	RFALSE	
?ELS11:	LOC	WINNER
	MOVE	PRSO,STACK
	RTRUE	


	.FUNCT	V-OPEN,F,STR
	FSET?	PRSO,CONTBIT /?ELS5
	PRINTI	"You must tell me how to do that to a "
	PRINTD	PRSO
	PRINTR	"."
?ELS5:	GETP	PRSO,P?CAPACITY
	ZERO?	STACK /?ELS9
	FSET?	PRSO,OPENBIT \?ELS14
	PRINTR	"It is already open."
?ELS14:	FSET	PRSO,OPENBIT
	FIRST?	PRSO \?THN24
	FSET?	PRSO,TRANSBIT \?ELS23
?THN24:	PRINTR	"Opened."
?ELS23:	FIRST?	PRSO >F \?ELS29
	NEXT?	F /?ELS29
	GETP	F,P?FDESC >STR
	ZERO?	STR /?ELS29
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" opens."
	CRLF	
	PRINT	STR
	CRLF	
	RTRUE	
?ELS29:	PRINTI	"Opening the "
	PRINTD	PRSO
	PRINTI	" reveals "
	CALL	PRINT-CONTENTS,PRSO
	PRINTR	"."
?ELS9:	FSET?	PRSO,DOORBIT \?ELS43
	FSET?	PRSO,OPENBIT \?ELS48
	PRINTR	"It is already open."
?ELS48:	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" opens."
	CRLF	
	FSET	PRSO,OPENBIT
	RTRUE	
?ELS43:	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" fails to open."


	.FUNCT	PRINT-CONTENTS,OBJ,F,N,1ST?=1
	FIRST?	OBJ >F \FALSE
?PRG6:	NEXT?	F >N /?KLU26
?KLU26:	ZERO?	1ST? /?ELS10
	SET	'1ST?,FALSE-VALUE
	JUMP	?CND8
?ELS10:	PRINTI	", "
	ZERO?	N \?CND8
	PRINTI	"and "
?CND8:	PRINTI	"a "
	PRINTD	F
	SET	'F,N
	ZERO?	F \?PRG6
	RTRUE	


	.FUNCT	V-CLOSE
	FSET?	PRSO,CONTBIT /?ELS5
	PRINTI	"You must tell me how to do that to a "
	PRINTD	PRSO
	PRINTR	"."
?ELS5:	FSET?	PRSO,SURFACEBIT /?ELS9
	GETP	PRSO,P?CAPACITY
	ZERO?	STACK /?ELS9
	FSET?	PRSO,OPENBIT \?ELS16
	FCLEAR	PRSO,OPENBIT
	PRINTR	"Closed."
?ELS16:	PRINTR	"It is already closed."
?ELS9:	FSET?	PRSO,DOORBIT \?ELS24
	FSET?	PRSO,OPENBIT \?ELS29
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is now closed."
	CRLF	
	FCLEAR	PRSO,OPENBIT
	RTRUE	
?ELS29:	PRINTR	"It is already closed."
?ELS24:	PRINTR	"You cannot close that."


	.FUNCT	CCOUNT,OBJ,CNT=0,X
	FIRST?	OBJ >X \?CND1
?PRG4:	FSET?	X,WEARBIT /?CND6
	INC	'CNT
?CND6:	NEXT?	X >X /?PRG4
?CND1:	RETURN	CNT


	.FUNCT	WEIGHT,OBJ,CONT,WT=0
	FIRST?	OBJ >CONT \?CND1
?PRG4:	EQUAL?	OBJ,PLAYER \?ELS8
	FSET?	CONT,WEARBIT \?ELS8
	INC	'WT
	JUMP	?CND6
?ELS8:	CALL	WEIGHT,CONT
	ADD	WT,STACK >WT
?CND6:	NEXT?	CONT >CONT /?PRG4
?CND1:	GETP	OBJ,P?SIZE
	ADD	WT,STACK
	RSTACK	


	.FUNCT	V-BUG
	PRINTR	"If there is a problem here, it is unintentional. You may report your problem to the address provided in your documentation."


	.FUNCT	V-SCRIPT
	GET	0,8
	BOR	STACK,1
	PUT	0,8,STACK
	PRINTI	"Here begins"
	PRINT	COPR-NOTICE
	CRLF	
	RTRUE	


	.FUNCT	V-UNSCRIPT
	PRINTI	"Here ends"
	PRINT	COPR-NOTICE
	CRLF	
	GET	0,8
	BAND	STACK,-2
	PUT	0,8,STACK
	RTRUE	


	.FUNCT	PRE-MOVE
	CALL	HELD?,PRSO
	ZERO?	STACK /FALSE
	PRINTR	"I don't juggle objects!"


	.FUNCT	V-MOVE
	FSET?	PRSO,TAKEBIT \?ELS5
	PRINTI	"Moving the "
	PRINTD	PRSO
	PRINTR	" reveals nothing."
?ELS5:	PRINTI	"You can't move the "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	V-LAMP-ON
	FSET?	PRSO,LIGHTBIT \?ELS3
	FSET?	PRSO,ONBIT \?ELS6
	PRINTR	"It is already on."
?ELS6:	FSET	PRSO,ONBIT
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is now on."
	CRLF	
	ZERO?	LIT \TRUE
	CALL	LIT?,HERE >LIT
	CRLF	
	CALL	V-LOOK
	RTRUE	
?ELS3:	PRINTR	"You can't turn that on."


	.FUNCT	V-LAMP-OFF
	FSET?	PRSO,LIGHTBIT \?ELS3
	FSET?	PRSO,ONBIT /?ELS6
	PRINTR	"It is already off."
?ELS6:	FCLEAR	PRSO,ONBIT
	ZERO?	LIT /?CND11
	CALL	LIT?,HERE >LIT
?CND11:	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is now off."
	CRLF	
	CALL	LIT?,HERE >LIT
	ZERO?	LIT \TRUE
	PRINTI	"It is now pitch black."
	CRLF	
	RTRUE	
?ELS3:	PRINTR	"You can't turn that off."


	.FUNCT	V-WAIT,NUM=3
	PRINTI	"Time passes..."
	CRLF	
?PRG3:	DLESS?	'NUM,0 \?ELS7
	JUMP	?REP4
?ELS7:	CALL	CLOCKER
	ZERO?	STACK /?CND5
	JUMP	?REP4
?CND5:	INC	'MOVES
	JUMP	?PRG3
?REP4:	SET	'CLOCK-WAIT,TRUE-VALUE
	RETURN	CLOCK-WAIT


	.FUNCT	PRE-BOARD,AV
	LOC	WINNER >AV
	EQUAL?	PRSO,WATER-CHANNEL /FALSE
	FSET?	PRSO,VEHBIT \?ELS5
	FSET?	AV,VEHBIT \FALSE
	PRINTI	"You are already in the "
	PRINTD	AV
	PRINTI	", cretin!"
	CRLF	
	RETURN	2
?ELS5:	PRINTI	"I suppose you have a theory on boarding a "
	PRINTD	PRSO
	PRINTI	"."
	CRLF	
	RETURN	2


	.FUNCT	V-BOARD,AV
	PRINTI	"You are now in the "
	PRINTD	PRSO
	PRINTI	"."
	CRLF	
	MOVE	WINNER,PRSO
	GETP	PRSO,P?ACTION
	CALL	STACK,M-ENTER
	RTRUE	


	.FUNCT	V-DISEMBARK
	LOC	WINNER
	EQUAL?	STACK,PRSO /?ELS5
	PRINTI	"You're not in that!"
	CRLF	
	RETURN	2
?ELS5:	FSET?	HERE,RLANDBIT \?ELS11
	PRINTI	"You are on your own feet again."
	CRLF	
	MOVE	WINNER,HERE
	RTRUE	
?ELS11:	PRINTI	"You realize, just in time, that getting out here would probably be fatal."
	CRLF	
	RETURN	2


	.FUNCT	V-BLAST
	PRINTR	"You can't blast anything by using words."


	.FUNCT	GOTO,RM,V?=1,LB,WLOC,AV=0,OLIT
	FSET?	RM,RLANDBIT /?PRD1
	PUSH	0
	JUMP	?PRD2
?PRD1:	PUSH	1
?PRD2:	SET	'LB,STACK
	LOC	WINNER >WLOC
	SET	'OLIT,LIT
	FSET?	WLOC,VEHBIT \?CND3
	GETP	WLOC,P?VTYPE >AV
?CND3:	ZERO?	LB \?THN15
	ZERO?	AV /?THN15
	FSET?	RM,AV \?THN11
?THN15:	FSET?	HERE,RLANDBIT \?ELS10
	ZERO?	LB /?ELS10
	ZERO?	AV /?ELS10
	EQUAL?	AV,RLANDBIT /?ELS10
	FSET?	RM,AV /?ELS10
?THN11:	ZERO?	AV /?ELS21
	PRINTI	"You can't go there in a "
	PRINTD	WLOC
	PRINTI	"."
	JUMP	?CND19
?ELS21:	PRINTI	"You can't go there without a vehicle."
?CND19:	CRLF	
	RFALSE	
?ELS10:	FSET?	RM,RMUNGBIT \?ELS30
	GETP	RM,P?LDESC
	PRINT	STACK
	CRLF	
	RFALSE	
?ELS30:	ZERO?	AV /?ELS37
	MOVE	WLOC,RM
	JUMP	?CND35
?ELS37:	MOVE	WINNER,RM
?CND35:	SET	'HERE,RM
	CALL	LIT?,HERE >LIT
	ZERO?	OLIT \?CND41
	ZERO?	LIT \?CND41
	RANDOM	100
	GRTR?	85,STACK \?CND41
	ZERO?	SPRAYED? /?ELS48
	PRINTI	"There are sinister gurgling noises in the darkness all around you!"
	CRLF	
	JUMP	?CND41
?ELS48:	EQUAL?	HERE,DARK-1,DARK-2 \?ELS53
	CALL	JIGS-UP,STR?30
	JUMP	?CND41
?ELS53:	CALL	JIGS-UP,STR?31
	RTRUE	
?CND41:	GETP	HERE,P?ACTION
	CALL	STACK,M-ENTER
	EQUAL?	HERE,RM \TRUE
	EQUAL?	ADVENTURER,WINNER /?ELS60
	PRINTI	"The "
	PRINTD	WINNER
	PRINTR	" leaves the room."
?ELS60:	ZERO?	V? /TRUE
	CALL	V-FIRST-LOOK
	RTRUE	


	.FUNCT	V-BACK
	PRINTR	"Sorry, my memory isn't that good. You'll have to give a direction."


	.FUNCT	PRE-POUR-ON
	PRINTR	"You can't pour that on anything."


	.FUNCT	V-POUR-ON
	PRINTR	"Foo!"


	.FUNCT	V-SPRAY
	CALL	V-SQUEEZE
	RSTACK	


	.FUNCT	V-SSPRAY
	CALL	PERFORM,V?SPRAY,PRSI,PRSO
	RSTACK	


	.FUNCT	V-SQUEEZE
	FSET?	PRSO,VILLAIN \?ELS3
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" does not understand this."
	JUMP	?CND1
?ELS3:	PRINTI	"How singularly useless."
?CND1:	CRLF	
	RTRUE	


	.FUNCT	PRE-OIL
	PRINTR	"You probably put spinach in your gas tank, too."


	.FUNCT	V-OIL
	PRINTR	"That's not very useful."


	.FUNCT	PRE-FILL,T
	ZERO?	PRSI \?CND1
	GETPT	HERE,P?GLOBAL >T
	ZERO?	T /?CND1
	PTSIZE	T
	CALL	ZMEMQB,GLOBAL-WATER,T,STACK
	ZERO?	STACK /?ELS8
	SET	'PRSI,GLOBAL-WATER
	RFALSE	
?ELS8:	PRINTR	"There is nothing to fill it with."
?CND1:	EQUAL?	PRSI,GLOBAL-WATER /FALSE
	CALL	PERFORM,V?PUT,PRSI,PRSO
	RTRUE	


	.FUNCT	V-FILL
	ZERO?	PRSI \?ELS5
	CALL	GLOBAL-IN?,GLOBAL-WATER,HERE
	ZERO?	STACK /?ELS10
	CALL	PERFORM,V?FILL,PRSO,GLOBAL-WATER
	RSTACK	
?ELS10:	PRINTR	"There's nothing to fill it with."
?ELS5:	PRINTR	"You may know how to do that, but I don't."


	.FUNCT	V-ADVENT
	PRINTR	"A hollow voice says ""Fool."""


	.FUNCT	V-DRINK
	CALL	V-EAT
	RSTACK	


	.FUNCT	V-EAT,EAT?=0,DRINK?=0,NOBJ=0
	FSET?	PRSO,FOODBIT /?PRD8
	PUSH	0
	JUMP	?PRD9
?PRD8:	PUSH	1
?PRD9:	SET	'EAT?,STACK
	ZERO?	EAT? /?ELS5
	IN?	PRSO,WINNER \?ELS5
	EQUAL?	PRSA,V?DRINK \?ELS12
	PRINTI	"How can I drink that?"
	JUMP	?CND10
?ELS12:	PRINTI	"Thank you very much. It really hit the spot."
	REMOVE	PRSO
?CND10:	CRLF	
	RTRUE	
?ELS5:	FSET?	PRSO,DRINKBIT /?PRD21
	PUSH	0
	JUMP	?PRD22
?PRD21:	PUSH	1
?PRD22:	SET	'DRINK?,STACK
	ZERO?	DRINK? /?ELS20
	IN?	PRSO,GLOBAL-OBJECTS /?THN28
	LOC	PRSO >NOBJ
	ZERO?	NOBJ /?ELS27
	IN?	NOBJ,WINNER \?ELS27
	FSET?	NOBJ,OPENBIT \?ELS27
?THN28:	PRINTI	"Thank you very much. I was rather thirsty (from all this talking, probably)."
	CRLF	
	REMOVE	PRSO
	RTRUE	
?ELS27:	PRINTR	"I'd like to, but it's in a closed container."
?ELS20:	ZERO?	EAT? \FALSE
	ZERO?	DRINK? \FALSE
	PRINTI	"I don't think that the "
	PRINTD	PRSO
	PRINTR	" would agree with you."


	.FUNCT	V-CURSES
	ZERO?	PRSO /?ELS5
	FSET?	PRSO,VILLAIN \?ELS11
	PRINTR	"Insults of this nature won't help you."
?ELS11:	PRINTR	"What a loony!"
?ELS5:	PRINTR	"Such language in a high-class establishment like this!"


	.FUNCT	V-LISTEN
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" makes no sound."


	.FUNCT	V-FOLLOW
	PRINTR	"You're nuts!"


	.FUNCT	V-STAY
	PRINTR	"You will be lost without me!"


	.FUNCT	V-PRAY
	PRINTR	"If you pray enough, your prayers may be answered."


	.FUNCT	V-LEAP,T,S
	ZERO?	PRSO /?ELS5
	IN?	PRSO,HERE \?ELS11
	FSET?	PRSO,VILLAIN \?ELS16
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" is too big to jump over."
?ELS16:	CALL	V-SKIP
	RSTACK	
?ELS11:	PRINTR	"That would be a good trick."
?ELS5:	GETPT	HERE,P?DOWN >T
	ZERO?	T /?ELS26
	PTSIZE	T >S
	EQUAL?	S,2 /?THN32
	EQUAL?	S,4 \?ELS31
	GETB	T,1
	VALUE	STACK
	ZERO?	STACK \?ELS31
?THN32:	PRINTI	"This was not a very safe place to try jumping."
	CRLF	
	CALL	PICK-ONE,JUMPLOSS
	CALL	JIGS-UP,STACK
	RSTACK	
?ELS31:	CALL	V-SKIP
	RSTACK	
?ELS26:	CALL	V-SKIP
	RSTACK	


	.FUNCT	V-SKIP
	CALL	PICK-ONE,WHEEEEE
	PRINT	STACK
	CRLF	
	RTRUE	


	.FUNCT	V-LEAVE
	CALL	DO-WALK,P?OUT
	RSTACK	


	.FUNCT	V-HELLO
	ZERO?	PRSO /?ELS5
	FSET?	PRSO,VILLAIN \?ELS11
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" bows his head to you in greeting."
?ELS11:	PRINTI	"I think that only schizophrenics say ""Hello"" to a "
	PRINTD	PRSO
	PRINTR	"."
?ELS5:	CALL	PICK-ONE,HELLOS
	PRINT	STACK
	CRLF	
	RTRUE	


	.FUNCT	PRE-READ
	ZERO?	LIT \?ELS5
	PRINTR	"It is impossible to read in the dark."
?ELS5:	ZERO?	PRSI /FALSE
	FSET?	PRSI,TRANSBIT /FALSE
	PRINTI	"How does one look through a "
	PRINTD	PRSI
	PRINTR	"?"


	.FUNCT	V-READ
	FSET?	PRSO,READBIT /?ELS5
	PRINTI	"How can I read a "
	PRINTD	PRSO
	PRINTR	"?"
?ELS5:	GETP	PRSO,P?TEXT
	PRINT	STACK
	CRLF	
	RTRUE	


	.FUNCT	V-LOOK-UNDER
	PRINTR	"There is nothing but dust there."


	.FUNCT	V-LOOK-BEHIND
	PRINTI	"There is nothing behind the "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	V-LOOK-INSIDE
	FSET?	PRSO,DOORBIT \?ELS5
	FSET?	PRSO,OPENBIT \?ELS8
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is open."
	JUMP	?CND6
?ELS8:	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" is closed."
?CND6:	CRLF	
	RTRUE	
?ELS5:	FSET?	PRSO,CONTBIT \?ELS16
	FSET?	PRSO,VICBIT \?ELS21
	PRINTR	"There is nothing special to be seen."
?ELS21:	CALL	SEE-INSIDE?,PRSO
	ZERO?	STACK /?ELS25
	FIRST?	PRSO \?ELS30
	CALL	PRINT-CONT,PRSO
	ZERO?	STACK \TRUE
?ELS30:	FSET?	PRSO,SURFACEBIT \?ELS34
	PRINTI	"There is nothing on the "
	PRINTD	PRSO
	PRINTR	"."
?ELS34:	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" is empty."
?ELS25:	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" is closed."
?ELS16:	PRINTI	"I don't know how to look inside a "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	SEE-INSIDE?,OBJ
	FSET?	OBJ,INVISIBLE /FALSE
	FSET?	OBJ,TRANSBIT /TRUE
	FSET?	OBJ,OPENBIT /TRUE
	RFALSE	


	.FUNCT	V-REPENT
	PRINTR	"It could very well be too late!"


	.FUNCT	PRE-BURN
	FSET?	PRSI,FLAMEBIT \?ELS5
	FSET?	PRSI,ONBIT /FALSE
?ELS5:	PRINTI	"With a "
	PRINTD	PRSI
	PRINTR	"??!?"


	.FUNCT	V-BURN
	FSET?	PRSO,BURNBIT \?ELS5
	IN?	PRSO,WINNER \?ELS10
	REMOVE	PRSO
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" catches fire."
	CRLF	
	CALL	JIGS-UP,STR?45
	RSTACK	
?ELS10:	REMOVE	PRSO
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" catches fire and is consumed."
?ELS5:	PRINTI	"I don't think you can burn a "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	PRE-TURN
	FSET?	PRSO,TURNBIT /FALSE
	PRINTR	"You can't turn that!"


	.FUNCT	V-TURN
	PRINTR	"This has no effect."


	.FUNCT	V-PUMP
	PRINTR	"I really don't see how."


	.FUNCT	V-INFLATE
	PRINTR	"How can you inflate that?"


	.FUNCT	V-DEFLATE
	PRINTR	"Come on, now!"


	.FUNCT	V-LOCK
	PRINTR	"It doesn't seem to work."


	.FUNCT	V-PICK
	PRINTR	"You can't pick that."


	.FUNCT	V-UNLOCK
	CALL	V-LOCK
	RSTACK	


	.FUNCT	V-CUT
	FSET?	PRSO,VILLAIN \?ELS5
	CALL	PERFORM,V?KILL,PRSO,PRSI
	RSTACK	
?ELS5:	FSET?	PRSO,BURNBIT \?ELS7
	FSET?	PRSI,WEAPONBIT \?ELS7
	REMOVE	PRSO
	PRINTI	"Your skillful "
	PRINTD	PRSI
	PRINTI	"smanship slices the "
	PRINTD	PRSO
	PRINTR	" into innumerable slivers which evaporate instantaneously."
?ELS7:	FSET?	PRSI,WEAPONBIT /?ELS13
	PRINTI	"I doubt that the ""cutting edge"" of a "
	PRINTD	PRSI
	PRINTR	" is adequate."
?ELS13:	PRINTI	"Strange concept, cutting the "
	PRINTD	PRSO
	PRINTR	"...."


	.FUNCT	V-KILL
	CALL	IKILL,STR?46
	RSTACK	


	.FUNCT	IKILL,STR
	ZERO?	PRSO \?ELS5
	PRINTI	"There is nothing here to "
	PRINT	STR
	PRINTR	"."
?ELS5:	FSET?	PRSO,VILLAIN /?ELS9
	FSET?	PRSO,VICBIT /?ELS9
	PRINTI	"I've known strange people, but fighting a "
	PRINTD	PRSO
	PRINTR	"?"
?ELS9:	ZERO?	PRSI /?THN16
	EQUAL?	PRSI,HANDS \?ELS15
?THN16:	PRINTI	"Trying to "
	PRINT	STR
	PRINTI	" a "
	PRINTD	PRSO
	PRINTR	" with your bare hands is suicidal."
?ELS15:	IN?	PRSI,WINNER /?ELS21
	PRINTI	"You aren't even holding the "
	PRINTD	PRSI
	PRINTR	"."
?ELS21:	FSET?	PRSI,WEAPONBIT /?ELS25
	PRINTI	"Trying to "
	PRINT	STR
	PRINTI	" the "
	PRINTD	PRSO
	PRINTI	" with a "
	PRINTD	PRSI
	PRINTR	" is suicidal."
?ELS25:	PRINTR	"You can't."


	.FUNCT	V-ATTACK
	CALL	IKILL,STR?47
	RSTACK	


	.FUNCT	V-SWING
	ZERO?	PRSI \?ELS5
	PRINTR	"Whoosh!"
?ELS5:	CALL	PERFORM,V?ATTACK,PRSI,PRSO
	RSTACK	


	.FUNCT	V-KICK
	CALL	HACK-HACK,STR?48
	RSTACK	


	.FUNCT	V-WAVE
	CALL	HACK-HACK,STR?49
	RSTACK	


	.FUNCT	V-RAISE
	CALL	HACK-HACK,STR?50
	RSTACK	


	.FUNCT	V-LOWER
	CALL	HACK-HACK,STR?50
	RSTACK	


	.FUNCT	V-RUB
	CALL	HACK-HACK,STR?51
	RSTACK	


	.FUNCT	V-PUSH
	CALL	HACK-HACK,STR?52
	RSTACK	


	.FUNCT	V-PUSH-TO
	PRINTR	"You can't push things to that."


	.FUNCT	PRE-MUNG
	EQUAL?	PRSO,BEAM /FALSE
	FSET?	PRSO,VICBIT /?ELS7
	CALL	HACK-HACK,STR?53
	RSTACK	
?ELS7:	ZERO?	PRSI \?ELS9
	PRINTI	"Trying to destroy the "
	PRINTD	PRSO
	PRINTR	" with your bare hands is suicidal."
?ELS9:	FSET?	PRSI,WEAPONBIT /FALSE
	PRINTI	"Trying to destroy the "
	PRINTD	PRSO
	PRINTI	" with a "
	PRINTD	PRSI
	PRINTR	" is quite self-destructive."


	.FUNCT	V-MUNG
	PRINTR	"You can't."


	.FUNCT	HACK-HACK,STR
	IN?	PRSO,GLOBAL-OBJECTS \?ELS5
	EQUAL?	PRSA,V?LOWER,V?RAISE,V?WAVE \?ELS5
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" isn't here!"
?ELS5:	PRINT	STR
	PRINTD	PRSO
	CALL	PICK-ONE,HO-HUM
	PRINT	STACK
	CRLF	
	RTRUE	


	.FUNCT	WORD-TYPE,OBJ,WORD,SYNS,?TMP1
	GETPT	OBJ,P?SYNONYM >SYNS
	PTSIZE	SYNS
	DIV	STACK,2
	SUB	STACK,1
	CALL	ZMEMQ,WORD,SYNS,STACK
	RSTACK	


	.FUNCT	V-KNOCK
	CALL	WORD-TYPE,PRSO,W?DOOR
	ZERO?	STACK /?ELS5
	PRINTR	"I don't think that anybody's home."
?ELS5:	PRINTI	"Why knock on a "
	PRINTD	PRSO
	PRINTR	"?"


	.FUNCT	V-CHOMP
	PRINTR	"I don't know how to do that. I win in all cases!"


	.FUNCT	V-FROBOZZ
	PRINTR	"The FROBOZZ Corporation created, owns, and operates this dungeon."


	.FUNCT	V-WIN
	PRINTR	"Naturally!"


	.FUNCT	V-YELL
	PRINTR	"Aarrrrrgggggggghhhhhhhhhhh!"


	.FUNCT	V-PLUG
	PRINTR	"This has no effect."


	.FUNCT	V-EXORCISE
	PRINTR	"What a bizarre concept!"


	.FUNCT	V-SHAKE,X
	FSET?	PRSO,VILLAIN \?ELS5
	PRINTR	"This seems to have no effect."
?ELS5:	FSET?	PRSO,TAKEBIT /?ELS9
	PRINTR	"You can't take it; thus, you can't shake it!"
?ELS9:	FSET?	PRSO,OPENBIT /?ELS13
	FIRST?	PRSO \?ELS13
	PRINTI	"It sounds like there is something inside the "
	PRINTD	PRSO
	PRINTR	"."
?ELS13:	FSET?	PRSO,OPENBIT \?ELS19
	FIRST?	PRSO \?ELS19
?PRG22:	FIRST?	PRSO >X \?REP23
	MOVE	X,HERE
	JUMP	?PRG22
?REP23:	PRINTR	"All of the objects spill onto the floor."
?ELS19:	PRINTI	"There's nothing in the "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	PRE-DIG
	ZERO?	PRSI \?CND1
	SET	'PRSI,HANDS
?CND1:	FSET?	PRSI,TOOLBIT /FALSE
	PRINTI	"Digging with the "
	PRINTD	PRSI
	PRINTR	" is very silly."


	.FUNCT	V-DIG
	PRINTR	"The ground is too hard here."


	.FUNCT	V-SMELL
	PRINTI	"It smells just like a "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	GLOBAL-IN?,OBJ1,OBJ2,T
	GETPT	OBJ2,P?GLOBAL >T
	ZERO?	T /FALSE
	PTSIZE	T
	SUB	STACK,1
	CALL	ZMEMQB,OBJ1,T,STACK
	RSTACK	


	.FUNCT	V-SWIM
	EQUAL?	HERE,ON-LAKE,IN-LAKE \?ELS5
	PRINTR	"What do you think you're doing?"
?ELS5:	EQUAL?	HERE,FLATHEAD-OCEAN \?ELS9
	PRINTR	"Between the rocks, wind, and waves, you wouldn't last a minute!"
?ELS9:	PRINTR	"Go jump in a lake!"


	.FUNCT	V-UNTIE
	PRINTR	"This cannot be tied, so it cannot be untied!"


	.FUNCT	PRE-TIE
	EQUAL?	PRSI,WINNER \FALSE
	PRINTR	"You can't tie it to yourself."


	.FUNCT	V-TIE
	PRINTI	"You can't tie the "
	PRINTD	PRSO
	PRINTR	" to that."


	.FUNCT	V-TIE-UP
	PRINTR	"You could certainly never tie it with that!"


	.FUNCT	V-MELT
	PRINTI	"I'm not sure that a "
	PRINTD	PRSO
	PRINTR	" can be melted."


	.FUNCT	V-MUMBLE
	PRINTR	"You'll have to speak up if you expect me to hear you!"


	.FUNCT	V-ALARM
	FSET?	PRSO,VILLAIN \?ELS5
	PRINTR	"He's wide awake, or haven't you noticed..."
?ELS5:	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" isn't sleeping."


	.FUNCT	V-ZORK
	PRINTR	"At your service!"


	.FUNCT	MUNG-ROOM,RM,STR
	FSET	RM,RMUNGBIT
	PUTP	RM,P?LDESC,STR
	RTRUE	


	.FUNCT	V-COMMAND
	FSET?	PRSO,VICBIT \?ELS5
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" pays no attention."
?ELS5:	PRINTR	"You cannot talk to that!"


	.FUNCT	V-CLIMB-ON
	FSET?	PRSO,VEHBIT \?ELS5
	CALL	V-CLIMB-UP,P?UP,TRUE-VALUE
	RSTACK	
?ELS5:	PRINTI	"You can't climb onto the "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	V-CLIMB-FOO
	EQUAL?	PRSO,ROPE,GLOBAL-ROPE \?ELS5
	PUSH	P?DOWN
	JUMP	?CND1
?ELS5:	PUSH	P?UP
?CND1:	CALL	V-CLIMB-UP,STACK,TRUE-VALUE
	RSTACK	


	.FUNCT	V-CLIMB-UP,DIR=P?UP,OBJ=0,X,?TMP1
	GETPT	HERE,DIR
	ZERO?	STACK /?ELS5
	CALL	DO-WALK,DIR
	RTRUE	
?ELS5:	ZERO?	OBJ \?ELS7
	PRINTR	"You can't go that way."
?ELS7:	ZERO?	OBJ /?ELS11
	GETPT	PRSO,P?SYNONYM >X
	PTSIZE	X
	CALL	ZMEMQ,W?WALL,X,STACK
	ZERO?	STACK /?ELS11
	PRINTR	"Climbing the walls is to no avail."
?ELS11:	PRINTR	"Bizarre!"


	.FUNCT	V-CLIMB-DOWN
	CALL	V-CLIMB-UP,P?DOWN
	RSTACK	


	.FUNCT	V-SEND
	FSET?	PRSO,VILLAIN \?ELS5
	PRINTI	"Why would you send for the "
	PRINTD	PRSO
	PRINTR	"?"
?ELS5:	PRINTR	"That doesn't make sends."


	.FUNCT	V-WIND
	PRINTI	"You cannot wind up a "
	PRINTD	PRSO
	PRINTR	"."


	.FUNCT	V-COUNT,OBJS,CNT
	EQUAL?	PRSO,BLESSINGS \?ELS5
	PRINTR	"Well, for one, you are playing ZORK...."
?ELS5:	PRINTR	"You have lost your mind."


	.FUNCT	V-PUT-UNDER
	PRINTR	"You can't do that."


	.FUNCT	V-PLAY
	FSET?	PRSO,VILLAIN \?ELS5
	PRINTI	"You are so engrossed in the role of the "
	PRINTD	PRSO
	PRINTI	" that you kill yourself, just as he would have done!"
	CRLF	
	CALL	JIGS-UP,STR?58
	RSTACK	
?ELS5:	PRINTR	"How peculiar!"


	.FUNCT	V-MAKE
	PRINTR	"You can't do that."


	.FUNCT	V-ENTER
	CALL	DO-WALK,P?IN
	RSTACK	


	.FUNCT	V-EXIT
	CALL	DO-WALK,P?OUT
	RSTACK	


	.FUNCT	V-CROSS
	PRINTR	"You can't cross that!"


	.FUNCT	V-SEARCH
	PRINTR	"You find nothing unusual."


	.FUNCT	V-FIND,L
	LOC	PRSO >L
	EQUAL?	PRSO,HANDS \?ELS5
	PRINTR	"Within six feet of your head, assuming you haven't left that somewhere."
?ELS5:	EQUAL?	PRSO,ME \?ELS9
	PRINTR	"You're around here somewhere..."
?ELS9:	EQUAL?	L,GLOBAL-OBJECTS \?ELS13
	PRINTR	"You find it."
?ELS13:	IN?	PRSO,WINNER \?ELS17
	PRINTR	"You have it."
?ELS17:	IN?	PRSO,HERE /?THN22
	EQUAL?	PRSO,PSEUDO-OBJECT \?ELS21
?THN22:	PRINTR	"It's right here."
?ELS21:	FSET?	L,VILLAIN \?ELS27
	PRINTI	"The "
	PRINTD	L
	PRINTR	" has it."
?ELS27:	FSET?	L,CONTBIT \?ELS31
	PRINTI	"It's in the "
	PRINTD	L
	PRINTR	"."
?ELS31:	PRINTR	"Beats me."


	.FUNCT	V-TELL
	FSET?	PRSO,VICBIT \?ELS5
	SET	'WINNER,PRSO
	LOC	WINNER >HERE
	RETURN	HERE
?ELS5:	PRINTI	"You can't talk to the "
	PRINTD	PRSO
	PRINTI	"!"
	CRLF	
	SET	'QUOTE-FLAG,FALSE-VALUE
	SET	'P-CONT,FALSE-VALUE
	RETURN	2


	.FUNCT	V-ANSWER
	PRINTI	"Nobody seems to be awaiting your answer."
	CRLF	
	SET	'P-CONT,FALSE-VALUE
	SET	'QUOTE-FLAG,FALSE-VALUE
	RTRUE	


	.FUNCT	V-REPLY
	PRINTI	"It is hardly likely that the "
	PRINTD	PRSO
	PRINTI	" is interested."
	CRLF	
	SET	'P-CONT,FALSE-VALUE
	SET	'QUOTE-FLAG,FALSE-VALUE
	RTRUE	


	.FUNCT	V-IS-IN
	IN?	PRSO,PRSI \?ELS5
	PRINTI	"Yes, it is "
	FSET?	PRSI,SURFACEBIT \?ELS10
	PRINTI	"on"
	JUMP	?CND8
?ELS10:	PRINTI	"in"
?CND8:	PRINTI	" the "
	PRINTD	PRSI
	PRINTR	"."
?ELS5:	PRINTR	"No, it isn't."


	.FUNCT	V-KISS
	PRINTR	"I'd sooner kiss a pig."


	.FUNCT	V-RAPE
	PRINTR	"What a (ahem!) strange idea."


	.FUNCT	FIND-IN,WHERE,WHAT,W
	FIRST?	WHERE >W /?KLU11
?KLU11:	ZERO?	W /FALSE
?PRG4:	FSET?	W,WHAT \?ELS8
	RETURN	W
?ELS8:	NEXT?	W >W /?PRG4
	RFALSE	


	.FUNCT	V-SAY,V
	FSET?	FRONT-DOOR,TOUCHBIT \?ELS5
	GET	P-LEXV,P-CONT
	EQUAL?	STACK,W?FROTZ \?ELS5
	ADD	P-CONT,2
	GET	P-LEXV,STACK
	EQUAL?	STACK,W?OZMOO \?ELS5
	SET	'P-CONT,FALSE-VALUE
	EQUAL?	HERE,MSTAIRS \?ELS12
	CRLF	
	CALL	GOTO,FRONT-DOOR
	RSTACK	
?ELS12:	PRINTR	"Nothing happens."
?ELS5:	CALL	FIND-IN,HERE,VICBIT >V
	ZERO?	V /?ELS18
	PRINTI	"You must address the "
	PRINTD	V
	PRINTR	" directly."
?ELS18:	GET	P-LEXV,P-CONT
	EQUAL?	STACK,W?HELLO \?ELS22
	SET	'QUOTE-FLAG,FALSE-VALUE
	RTRUE	
?ELS22:	SET	'QUOTE-FLAG,FALSE-VALUE
	SET	'P-CONT,FALSE-VALUE
	PRINTR	"Talking to yourself is said to be a sign of impending mental collapse."


	.FUNCT	V-INCANT
	PRINTI	"The incantation echoes back faintly, but nothing else happens."
	CRLF	
	SET	'QUOTE-FLAG,FALSE-VALUE
	SET	'P-CONT,FALSE-VALUE
	RTRUE	


	.FUNCT	V-SPIN
	PRINTR	"You can't spin that!"


	.FUNCT	V-THROUGH,M
	FSET?	PRSO,DOORBIT \?ELS5
	CALL	OTHER-SIDE,PRSO
	CALL	DO-WALK,STACK
	RTRUE	
?ELS5:	FSET?	PRSO,VEHBIT \?ELS7
	CALL	PERFORM,V?BOARD,PRSO
	RTRUE	
?ELS7:	FSET?	PRSO,TAKEBIT /?ELS9
	PRINTI	"You hit your head against the "
	PRINTD	PRSO
	PRINTR	" as you attempt this feat."
?ELS9:	IN?	PRSO,WINNER \?ELS13
	PRINTR	"That would involve quite a contortion!"
?ELS13:	CALL	PICK-ONE,YUKS
	PRINT	STACK
	CRLF	
	RTRUE	


	.FUNCT	V-WEAR
	FSET?	PRSO,WEARBIT /?ELS5
	PRINTI	"You can't wear the "
	PRINTD	PRSO
	PRINTR	"."
?ELS5:	CALL	PERFORM,V?TAKE,PRSO
	RTRUE	


	.FUNCT	V-THROW-OFF
	PRINTR	"You can't throw anything off of that!"


	.FUNCT	V-$VERIFY
	PRINTI	"Verifying game..."
	CRLF	
	VERIFY	 \?ELS7
	PRINTR	"Game correct."
?ELS7:	CRLF	
	PRINTR	"** Game File Failure **"


	.FUNCT	V-STAND
	LOC	WINNER
	FSET?	STACK,VEHBIT \?ELS5
	LOC	WINNER
	CALL	PERFORM,V?DISEMBARK,STACK
	RTRUE	
?ELS5:	PRINTR	"You are already standing, I think."


	.FUNCT	V-PUT-BEHIND
	PRINTR	"That hiding place is too obvious."


	.FUNCT	DO-WALK,DIR
	SET	'P-WALK-DIR,DIR
	CALL	PERFORM,V?WALK,DIR
	RSTACK	


	.FUNCT	V-WALK-TO
	IN?	PRSO,HERE /?THN6
	CALL	GLOBAL-IN?,PRSO,HERE
	ZERO?	STACK /?ELS5
?THN6:	PRINTR	"It's here!"
?ELS5:	PRINTR	"You should supply a direction!"


	.FUNCT	OTHER-SIDE,DOBJ,P=0,T
?PRG1:	NEXTP	HERE,P >P
	LESS?	P,LOW-DIRECTION /FALSE
	GETPT	HERE,P >T
	PTSIZE	T
	EQUAL?	STACK,DEXIT \?PRG1
	GETB	T,DEXITOBJ
	EQUAL?	STACK,DOBJ \?PRG1
	RETURN	P


	.FUNCT	V-DRINK-FROM
	PRINTR	"How peculiar!"


	.FUNCT	V-LEAN-ON
	PRINTR	"Are you so very tired, then?"

	.ENDI
