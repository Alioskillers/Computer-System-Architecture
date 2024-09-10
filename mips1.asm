.data
a: .word 4,9,10,10,15,2,3 # array a
b: .word 0,0,0,0,0,0,0 # array b to rearange in the values of array a
length: .word 7 # length
key: .word 4 # key is the number i want to find

.text
.globl main

main:

la $s0,a 
la $s1,b
la $s4,length
la $s5,key

jal rep1torep2
jal rep2torep1
jal search

# exit program
li $v0,10
syscall


rep1torep2:

addi $sp,$sp,-16 # adjusting the stack for 4 places
sw $ra,0($sp) # 
sw $a0,4($sp) # push into the stack
sw $s1,8($sp) #
sw $s2,12($sp) #

li $s3,0 # index =0
li $s4,0 # int i =0

bge $a0, $a1, loop1

sll $a2, $a0,2 #
add $a2, $a2,$a3 # $a2= a[i]
lw $a2,0($a2) #

sll $t0,$t1,2 # $t0= index
add $t0,$t0,$t2 # b[index]= a[i] $a2
sw $a2,0($t1) #

addi $t1,$t1,1 #index++

sll $a0,$a0,1 # i=i*2+1
addi $a0,$a0,1 #
jal rep1torep2 # recursive call

lw $ra,0($sp) #
lw $a0, 4($sp) #
addi $sp, $sp,8 # pop from the stack
jr $ra # retun address

addi $sp,$sp,-8 #
sw $ra, 0($sp) # push to the stack
sw $a0,4($sp) #

sll $s5,$s5,1 # i=i*2+2
addi $s5,$s5,2 #

jal rep1torep2 # recursive call

lw $ra,0($sp) #
lw $a0,4($sp) # pop from the stack
addi $sp, $sp, 8 #
jr $ra #

loop1:
jr $ra # retun return address


rep2torep1:

addi $sp,$sp,-24 # adjusting the stack for 4 items
sw $ra,0($sp) # return address
sw $a1,4($sp) # level
sw $a2,8($sp) # height
sw $t0,12($sp) # L
sw $s0,16($sp) # array [a]
sw $s1,20($sp) # array [b]

lw $s0,0($s0) # array a base address
lw $s1,0($s1) # array b base address

L1: # to check the codition every time before entring the other loop
li $a0,0 # int i=0 $a0
li $a1,0 # level=0 $a1
bge $a1,$a2,exit # if(length>=height) go to exit label

loop_rep2torep1:

move $a3,$a1 # j= level
bge $a3,$t0, end_loop_rep2torep1 # if(j>=L) go to end_loop_rep2torep1

sll $t1,$a3,2 #
add $t1,$t1,$s0 # a[j] $t2
lw $t2,0($t1) #

sll $t3,$s1,2 #
add $t3,$t3,$s1 # b[i] $t4
lw $t4,0($t3) # 

li $t2,-1 # a[j] = -1
sw $t2,0($t1) # storing it back into the registry

addi $a1,$a1,1 # i++

sub $t5,$a2,$a1 # height - level $t5
li $t6,2 # $t6=2

sllv $t6,$t6,$t5 # 2^(height-level)
add $a3,$a3,$t6 # j+ 2^(height-level)
addi $a3,$a3,-1 # j+ 2^(height-level)-1

while_loop:

bge $a3,$t0,loop_rep2torep1 # if j >= L go to loop_rep2torep1 label

sll $t1,$a3,2 #
add $t1,$t1,$s0 # a[j] $t7
lw $t7,0($t1) #

bne $t7,$zero,loop_rep2torep1 # if the element is not equal to zero loop again
addi $a3,$a3,1 # j++

j while_loop # recursive call


end_loop_rep2torep1:

addi $a1,$a1,1 # level++
j L1 # jump to label L1 to loop again

exit:

lw $ra,0($sp) #
lw $a1,4($sp) #
lw $a2,8($sp) #
lw $t0,12($sp) # poping out of the stack
lw $s0,16($sp) #
lw $s1,20($sp) # 
addi $sp,$sp,24 #
jr $ra




search:

li $a0,0 # int i=0 $a0

addi $sp,$sp,-12 # adjustin th stack for 3 items
sw $ra,0($sp)
sw $a0,4($sp)
sw $t0,8($sp)

loop:
bge $a0,$s4,not_found # check if i greater than or equal to the length then go to exit label

sll $t1,$a0,2 #
add $t1,$t1,$s0 # a[i] $t0
lw $t0,0($t1) #

beq $t0,$s5,found # if a[i]==key go to found label
addi $a0,$a0,1 # i++

j loop # repeat the loop

found:
move $v0,$a0 # return i if the element is found  note: the i=element
j exit_search # jump to exit label

not_found:
li $v0,-1 # if the element is not found return -1   note: -1 = element is not found

exit_search:

lw $ra,0($sp) #
lw $a0,4($sp) # poping out of the stack
lw $t0,8($sp) #
addi $sp,$sp,12 #

jr $ra # jump to the return address