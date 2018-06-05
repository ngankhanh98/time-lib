.data
	p_day: .space 3
	p_month: .space 3
	p_year: .space 5

	time: .asciiz "12/01/1998"
	time_1: .asciiz "--/--/----"
	convert_time: .space 20

	# days
	daysOfWeek: .word cn, t2, t3, t4, t5, t6, t7
	sun: .asciiz " Sun"
	mon: .asciiz " Mon"
	tue: .asciiz " Tue"
	wed: .asciiz " Wed"
	thu: .asciiz " Thu"
	fri: .asciiz " Fri"
	sat: .asciiz " Sat"

	# months
	jan: .asciiz "January"
	feb: .asciiz "February"
	mar: .asciiz "March"
	apr: .asciiz "April"
	may: .asciiz "May"
	jun: .asciiz "June"
	jul: .asciiz "July"
	aug: .asciiz "August"
	sep: .asciiz "September"
	oct: .asciiz "October"
	nov: .asciiz "November"
	dec: .asciiz "December"
	songay: .word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

	# jump table
	jump: .word m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12
	menutable: .word o1, o2, o3, o4, o5, o6, o7
	# prompt
	prompt1: .asciiz "\nNhap ngay DAY: "
	prompt2: .asciiz "\nNhap thang MONTH: "
	prompt3: .asciiz "\nNhap nam YEAR: "
	# menu
	MENU: .asciiz 	"\n----------Ban hay chon 1 trong cac thao tac duoi day----------\n"
	option1: .asciiz	"1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
	option2: .asciiz	"2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n"
	option2a: .asciiz			"\tA. MM/DD/YYYY\n"
	option2b: .asciiz			"\tB. Month DD, YYYY\n"
	option2c: .asciiz			"\tC. DD Month, YYYY\n"
	option3: .asciiz	"3. Cho biet ngay vua nhap la ngay thu may trong tuan:\n"
	option4: .asciiz	"4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong\n"
	option5: .asciiz	"5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n"
	option6: .asciiz	"6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n"
	option7: .asciiz 	"7. Kiem tra du lieu nhap vao\n"
	stuff: .asciiz	"---------------------------------------------------------------\n"
	option: .asciiz	"Lua chon: "
	type: .asciiz "Loai (A/B/C): "
	result: .asciiz "\nKet qua: "
	m_continue: .asciiz "\nChon (1) de tiep tuc, (0) de thoat:  "
	leap: .asciiz " la nam nhuan."
	notleap: .asciiz " khong la nam nhuan."
	errorMessage: "\nKiem tra du lieu nhap vao. "
	sa: .asciiz "Du lieu dung. "
	ngay: .asciiz " ngay - "
	nam: .asciiz " nam"
.text
	.globl main
main:
	con:
	la	$a0, time
	jal	menu

	la	$a0, m_continue
	li	$v0, 4
	syscall

	li	$v0, 5
	syscall	
	beq	$v0, $0, EOP
	j	con
EOP:
	li	$v0, 10
	syscall
	
#------------------------------------------------------------
prompt:
	addi	$sp, $sp, -36 
	sw	$ra, 32($sp)
	sw	$a0, 28($sp)
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$t2, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)

prompt_again:
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	la	$v0, 8
	la	$a0, p_day
	li	$a1, 3	
	syscall
	move	$t0, $a0

	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	la	$v0, 8
	la	$a0, p_month
	li	$a1, 3	
	syscall
	move	$t1, $a0

	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	la	$v0, 8
	la	$a0, p_year
	li	$a1, 5
	syscall
	move	$t2, $a0

	lw	$a3, 12($sp)
	move	$a0, $t0
	move	$a1, $t1
	move	$a2, $t2
	jal	date	
	move	$a0, $v0
	move	$t0, $v0
	jal	checkdate	# kiem tra hop le

	bne	$v0, $0, excepted

	la	$a0, errorMessage
	li	$v0, 4
	syscall
	j	prompt_again

excepted:
	move	$v0, $t0
		

	lw	$ra, 32($sp)
	lw	$a0, 28($sp)
	lw	$t0, 24($sp)
	lw	$t1, 20($sp)
	lw	$t2, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 36

	jr 	$ra
	
#------------------------------------------------------------
date: 
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)


	move	$a0, $a3
	lw	$a1, 12($sp)
	jal	strcpy
	move	$a0, $v0

	li	$t0, 47
	sb	$t0, 2($a0)
	
	la	$a0, 3($a0)
	lw	$a1, 8($sp)
	jal	strcpy
	la	$a0, -3($v0)
	
	li	$t0, 47
	sb	$t0, 5($a0)
	
	la	$a0, 6($a0)
	lw	$a1, 4($sp)
	
	jal	strcpy
	la	$a0, -6($v0)

	move	$v0, $a0
	

	lw	$ra, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 20
	
	jr	$ra
	
#------------------------------------------------------------
menu:
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	
	jal	prompt
	sw	$v0, 0($sp)
	
	li	$v0, 4
	la	$a0, MENU
	syscall
	
	la	$a0, option1
	syscall 
	
	la	$a0, option2
	syscall 

	la	$a0, option2a
	syscall 

	la	$a0, option2b
	syscall 

	la	$a0, option2c
	syscall 

	la	$a0, option3
	syscall 

	la	$a0, option4
	syscall 

	la	$a0, option5
	syscall 

	la	$a0, option6
	syscall 

	la	$a0, option7
	syscall 

	la	$a0, stuff
	syscall 

	la	$a0, option
	syscall

	la	$v0, 5
	syscall
	
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, menutable
	add	$t0, $t0, $v0
	lw	$t0, ($t0)
	jr	$t0

o1:
	lw	$a0, ($sp)
	li	$v0, 4
	syscall
	j	EOM
o2:
	li	$v0, 4
	la	$a0, type
	syscall

	li	$v0, 12
	syscall
	
	lw	$a0, ($sp)
	move	$a1, $v0
	jal	convert
	sw	$v0, ($sp)
	
	la	$a0, result
	li	$v0, 4
	syscall
	lw	$a0, ($sp)
	
	li	$v0, 4
	syscall
	j	EOM
o3:
	la	$a0, result
	li	$v0, 4
	syscall

	lw	$a0, ($sp)
	jal	weekday
	move	$a0, $v0
	li	$v0, 4
	syscall
	j	EOM	
o4:
	la	$a0, result
	li	$v0, 4
	syscall

	lw	$a0, ($sp)
	jal	year
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	lw	$a0, ($sp)
	jal	leapyear
	beq	$v0, $0, khongnhuan
	
	la	$a0, leap
	li	$v0, 4
	syscall
	j	EOM
khongnhuan:
	la	$a0, notleap
	li	$v0, 4
	syscall
	j	EOM
	
o5:
	la	$a0, time_1
	jal	prompt
	move	$a0, $v0
	jal	thisIsMagic
	move	$a1, $v0


	lw	$a0, ($sp)
	jal	thisIsMagic
	move	$a0, $v0
	
	sub	$a0, $a0, $a1
	slt	$t0, $a0, $0	# if(thisIsMagic(time) - thisIsMagic(time_1) < 0)
	beq	$t0, $0, print
	li	$t0, -1
	mult	$a0, $t0
	mflo	$a0
	j 	print
print:
	move	$t0, $a0	# $t0 = so ngay ne
	
	la	$a0, result
	li	$v0, 4
	syscall

	move 	$a0, $t0	
	li	$v0, 1
	syscall
	move	$t0, $a0
	
	la	$a0, ngay
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	li	$t0, 365
	div	$a0, $t0
	mflo	$a0
	li	$v0, 1
	syscall
	la	$a0, nam
	li	$v0, 4
	syscall
	
	j	EOM
o6:
	lw	$a0, 0($sp)
	jal	leapyear
	move	$t0, $v0 

	jal	year
	move	$a0, $v0

	bne	$t0, $0, nhuan

	li	$t0, 4		# 2015 mod 4 = 3
	div	$v0, $t0
	mfhi	$v0
	sub	$a0, $a0, $v0	# 2015 - 3 = 2012
	j 	nhuan
nhuan:	
	move	$t0, $a0
	
	la	$a0, result
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	
	addi	$a0, $a0, 4	
	li	$v0, 1
	syscall
	move	$t0, $a0
	
	li	$a0, 32
	li	$v0, 11
	syscall

	addi	$a0, $t0, 4
	li	$v0, 1
	syscall

	j	EOM

o7: 
	lw	$a0, 0($sp)
	jal	checkdate
	beq	$v0, $0, khong
	la	$a0, sa
	li	$v0, 4
	syscall
	j 	EOM
khong:
	la	$a0, errorMessage
	li	$v0, 4
	syscall
	j 	EOM

EOM:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$v0, 0($sp)

	addi	$sp, $sp, 12
	jr 	$ra
	
# -----------------------------------------------------------
convert:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$t0, 12($sp)
	sw	$t1, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)

	li	$t0, 65
	bne 	$a1, 65, B
	# s0 = 'MM'
	la	$s0, p_month
	
	lb	$t0, 3($a0)
	sb	$t0, ($s0)

	lb	$t0, 4($a0)
	sb	$t0, 1($s0)
	
	# s1 = 'DD'
	la	$s1, p_day
	
	lb	$t0, ($a0)
	sb	$t0, ($s1)

	lb	$t0, 1($a0)
	sb	$t0, 1($s1)

	# $a0 = strcpy($a0, $s0)
	la 	$a1, ($s0)
	jal 	strcpy
	move 	$a0, $v0
 
	la	$a0, 3($a0)

	# $a0 = strcpy($a0, $s1)
	la 	$a1, ($s1)
	jal 	strcpy
	la 	$a0, -3($v0)
	j 	return	
B:
	li	$t0, 66
	bne	$a1, $t0, C

	jal	nameOfMonth
	move	$a1, $v0

	move	$a0, $v0
	jal	strlength
	move	$t0, $v0

	la	$a0, convert_time
	jal	strcpy
	move	$a0, $v0

	add	$a0, $a0, $t0
	
	li	$t1, 32
	sb	$t1, ($a0)
	
	la	$s0, time

	addi	$a0, $a0, 1
	lb	$t1, ($s0)
	sb	$t1, ($a0)

	addi	$a0, $a0, 1
	addi	$s0, $s0, 1
	lb	$t1, ($s0)
	sb	$t1, ($a0)

	addi	$a0, $a0, 1
	li	$t1, 44
	sb	$t1, ($a0)
	
	addi	$a0, $a0, 1
	li	$t1, 32
	sb	$t1, ($a0)
	
	addi	$a0, $a0, 1
	la	$a1, time
	addi	$a1, $a1, 6
	jal	strcpy


	sub	$a0, $a0, $t0
	addi	$a0, $a0, -5

	j 	return 
C:
	la	$a1, ($a0)	# time
	la	$a0, convert_time
	

	lb	$s0, 0($a1)
	sb	$s0, 0($a0)
	lb	$s0, 1($a1)
	sb	$s0, 1($a0)
	li	$s0, 32
	sb	$s0, 2($a0)

	la	$a0, time
	jal	nameOfMonth
	move	$a1, $v0
	
	move	$a0, $v0
	jal	strlength
	move	$t0, $v0
	
	la 	$a0, convert_time
	la	$a0, 3($a0)
	jal	strcpy
	la	$a0, -3($v0)
	
	add	$a0, $a0, $t0
	addi	$a0, $a0, 3

	li	$t1, 44
	sb	$t1, 0($a0)
	
	addi	$a0, $a0, 1
	li	$t1, 32
	sb	$t1, ($a0)
	

	addi	$a0, $a0, 1
	la	$a1, time
	addi	$a1, $a1, 6
	jal	strcpy
	move	$a0, $v0
	
	sub 	$a0, $a0, $t0
	addi	$a0, $a0, -5

	
	j 	return 
	
return:
	move	$v0, $a0
	lw	$ra, 16($sp)
	lw	$t0, 12($sp)
	lw	$t1, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addi	$sp, $sp, 20

	jr 	$ra


#---------------------------------------------------------
strcpy:
	addi 	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$t0, 0($sp)

	la	$s0, ($a0)
	la	$s1, ($a1)
LOOP:
	lb 	$t0, 0($s1)
	beq	$t0, $0, END
	sb	$t0, ($s0)
	addi	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j	LOOP
END:
	
	la	$v0, ($a0)


	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$t0, 0($sp)
	addi 	$sp, $sp, 16

	jr 	$ra

# --------------------------------------------
day:
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a0)
	addi	$t0, $t0, -48
	
	li	$t1, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a0)
	addi	$t1, $t1, -48
	add	$t0, $t0, $t1

	move	$v0, $t0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# --------------------------------------------
month:
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$a0, 3($a0)
	jal	day
	move	$v0, $v0

	lw	$ra, 0($sp)
	addi 	$sp, $sp, 4
	
	jr	$ra

# --------------------------------------------

year:
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	la	$a0, 6($a0)
	jal	day
	move	$t0, $v0
	
	li	$t1, 100
	mult	$t0, $t1
	mflo	$t0

	la	$a0, 2($a0)
	jal	day
	add	$t0, $t0, $v0

	move	$v0, $t0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# ------------------------------------------------
leapyear:
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$a0, 0($sp)
	
	jal	year
	move	$a0, $v0
	

	li	$t0, 400
	div	$a0, $t0
	mfhi	$t0
	beq 	$t0, $0, true	# du = 0 <=> chia het cho 400 -> true
	
	li	$t0, 4
	div	$a0, $t0
	mfhi	$t0
	bne 	$t0, $0, false	# du != 0 <=> khong chia het 4 -> false		
	
	li	$t0, 100
	div	$a0, $t0
	mfhi	$t0
	beq	$t0, $0, false	# du !=0 <=> khong chia het 100 + chia het 4 -> true
	
	
true:
	li	$v0, 1
	j	break
false:
	li	$v0, 0
	j	break
break:
	
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$a0, 0($sp)
	
	addi	$sp, $sp, 12

	jr	$ra
#---------------------------------------------
strlength:
	addi	$sp, $sp, -12 
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)
	
	li	$t0, 0
continue:
	lb	$t1, ($a0)
	beq	$t1, $0, EOS
	addi	$t0, $t0, 1
	addi	$a0, $a0, 1
	j 	continue
EOS:
	la	$v0, ($t0)

	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)
	addi	$sp, $sp, 12 

	jr 	$ra

#-----------------------------------------------
nameOfMonth:
	addi	$sp, $sp, -12 
	sw	$a0, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	jal	month
	addi	$a0, $v0, -1
	
	la	$s0, jump
	sll	$a0, $a0, 2
	add	$a0, $a0, $s0
	lw	$a0, ($a0)
	jr	$a0

m1:
	la	$v0, jan
	j	END_SWITCH
m2:
	la	$v0, feb
j	END_SWITCH
m3:
	la	$v0, mar
m4:
	la	$v0, apr
j	END_SWITCH
m5:	
	la	$v0, may
j	END_SWITCH
m6:	
	la	$v0, jun
j	END_SWITCH
m7:
	la	$v0, jul
j	END_SWITCH
m8:
	la	$v0, aug
j	END_SWITCH
m9:
	la	$v0, sep 
j	END_SWITCH
m10:
	la	$v0, oct
j	END_SWITCH
m11:
	la	$v0, nov
j	END_SWITCH
m12:	
	la	$v0, dec
j	END_SWITCH
END_SWITCH:
	
	lw	$a0, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12 

	jr 	$ra

# -------------------------------------
gettime:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$t0, 8($sp)
	sw	$t1, 4($sp)
	sw	$t2, 0($sp)

	jal	year
	move	$t0, $v0

	la	$a0, ($a1)
	jal	year
	move	$t1, $v0

	sub	$v0, $t1, $t0

	slt	$t0, $v0, $0
	beq	$t0, $0, EOG
	li	$t0, -1
	mult	$v0, $t0
	mflo	$v0
EOG:
	
	lw	$ra, 12($sp)
	lw	$t0, 8($sp)
	lw	$t1, 4($sp)
	lw	$t2, 0($sp)

	addi	$sp, $sp, 16

	jr	$ra
	
weekday:
	addi 	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$a0, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	sw	$t2, 12($sp)
	sw	$t3, 8($sp)
	sw	$t4, 4($sp)
	sw	$s0, 0($sp)
	
	
	jal	year
	move	$t2, $v0

	lw	$a0, 24($sp)
	jal	day
	move	$t0, $v0
	
	lw	$a0, 24($sp)
	jal	month
	move	$t1, $v0

	li	$t3, 3
	slt	$t3, $t1, $t3
	beq	$t3, $0, congthuc
	addi	$t1, $t1, 12
	addi	$t2, $t2, -1
	j 	congthuc
congthuc:
	move	$s0, $t0	# $s0 = ngay
	
	li	$t4, 2
	mult	$t1, $t4	# thang * 2
	mflo	$t0		# $t0 = thang * 2

	add	$s0, $s0, $t0	# $s0 = ngay + 2* thang

	addi	$t1, $t1, 1	# $t1 = thang + 1

	li	$t4, 3		
	mult	$t1, $t4	# (thang + 1) * 3
	mflo	$t1		# $t1 = (thang + 1) * 3

	li	$t4, 5
	div	$t1, $t4	# ((thang + 1) * 3) div 5
	mflo	$t1		# $t1 = ((thang + 1) * 3) div 5

	add	$s0, $s0, $t1  	# $s0 = ngay + 2* thang + ((thang + 1) * 3) div 5
	
	add	$s0, $s0, $t2	# $s0 = ngay + 2* thang + ((thang + 1) * 3) div 5 + nam
	li	$t4, 4
	div	$t2, $t4	# nam div 4
	mflo	$t2		# $t2 = nam div 4
	
	add	$s0, $s0, $t2 	# $s0 = ngay + 2* thang + ((thang + 1) * 3) div 5 + nam + nam div 4

	li	$t4, 7
	div	$s0, $t4
	mfhi	$s0

	sll	$s0, $s0, 2
	la	$t0, daysOfWeek
	add	$t0, $t0, $s0
	lw	$t0, ($t0)
	jr	$t0
cn:	
	la	$v0, sun
	j 	EOW
t2:
	la	$v0, mon
	j 	EOW
t3:
	la	$v0, tue
	j 	EOW
t4:
	la	$v0, wed
	j 	EOW
t5:
	la	$v0, thu
	j 	EOW
t6:
	la	$v0, fri
	j 	EOW
t7:
	la	$v0, sat
	j 	EOW
EOW:
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	lw	$t0, 20($sp)
	lw	$t1, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	lw	$s0, 0($sp)
	addi 	$sp, $sp, 32
	
	jr	$ra
#---------------------------------------------------
checkdate:
	addi	$sp, $sp, -32
	sw	$a0, 28($sp)
	sw	$ra, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	sw	$t2, 12($sp)
	sw	$t3, 8($sp)
	sw	$t4, 4($sp)
	sw	$s0, 0($sp)
	jal	day
	move	$t0, $v0
	
	jal	month
	move	$t1, $v0
	
	lw	$a0, 28($sp)
	jal	year
	move	$t2, $v0

	li	$t3, 13
	slt	$t3, $t1, $t3	# if(thang<13)
	beq	$t3, $0, invalid
	
	la	$s0, songay
	addi	$t4, $t1, -1
	sll	$t4, $t4, 2
	add	$s0, $s0, $t4
	lw	$s0, ($s0)	# s0 = so ngay cua thang do

	li	$t4, 2
	bne	$t1, $t4, ktngay	# if (thang != 2) 
	lw	$a0, 28($sp)
	jal	leapyear
	beq	$v0, $0, ktngay		# if (khong la nam nhuan)
	addi	$s0, $s0, 1
	j 	ktngay
ktngay:	
	slt	$t4, $s0, $t0
	bne	$t4, $0, invalid
	j	valid
invalid:
	li	$v0, 0
	j	end
valid:	
	li	$v0, 1
end:
	lw	$a0, 28($sp)
	lw	$ra, 24($sp)
	lw	$t0, 20($sp)
	lw	$t1, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 32

	jr 	$ra
	
#-------------------------------------------------
thisIsMagic:
	addi 	$sp, $sp, -28
	sw	$a0, 24($sp)
	sw	$ra, 20($sp)
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t2, 8($sp)
	sw	$t3, 4($sp)
	sw	$s0, 0($sp)
	
	jal	day
	move	$t0, $v0

	jal	month
	move	$t1, $v0

	lw	$a0, 24($sp)
	jal	year
	move	$t2, $v0

	
	move	$s0, $t2	# $s0 = year
	
	li	$t3, 365
	mult	$s0, $t3
	mflo	$s0		# $s0 = year*365

	li	$t3, 4
	div	$t2, $t3
	mflo	$t3		# $t3 = year/4
	
	add	$s0, $s0, $t3	# $s0 = year*365+year/4
	
	li	$t3, -100
	div	$t2, $t3
	mflo	$t3		# $t3 = -year/100
	
	add	$s0, $s0, $t3	# $s0 = year*365+year/4-year/100

	li	$t3, 400
	div	$t2, $t3
	mflo	$t3		# $t3 = year/400
	
	add	$s0, $s0, $t3	# $s0 = year*365+year/4-year/100+year/400
	
	li	$t3, 153
	mult	$t1, $t3
	mflo	$t1 		# $t1 = 153*month
	addi	$t1, $t1, -457	# $t1 = 153*month - 457

	li	$t3, 5
	div	$t1, $t3
	mflo	$t1		# $t1 = (153*month - 457)/5

	add	$s0, $s0, $t1	# $s0 = year*365+year/4-year/100+year/400+(153*month - 457)/5
	add	$s0, $s0, $t0	# $s0 = year*365+year/4-year/100+year/400+(153*month - 457)/5 + day

	addi 	$s0, $s0, -306	# $s0 = year*365+year/4-year/100+year/400+(153*month - 457)/5 + day

	move	$v0, $s0

	lw	$a0, 24($sp)
	lw	$ra, 20($sp)
	lw	$t0, 16($sp)
	lw	$t1, 12($sp)
	lw	$t2, 8($sp)
	lw	$t3, 4($sp)
	lw	$s0, 0($sp)
	
	addi 	$sp, $sp, 28

	jr	$ra
