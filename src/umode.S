# Derived from umode.S

# The following template presents the base framework for a test with 
# several pmp regions and using user mode. 
#  - The PMP setup function is the ran just after the main function
#    and fills the pmp CSRs (both addresses and configs).
#  - The test start function performs the accesses that are tested.
#  - The data regions both hold the same raw binary data.bin, an iterative
#    concatenation of 256 32-bits integers (0x00000000, 0x00000001, etc.)

# PMP address registers contains:
#  63   54 53              0
# |   0   |    addr[55:2]   |

# Those addresses can be verified in the dump! Data bins have a length of 0x100

.equiv PMP_ADDR0, 0x80002d00  # Should be equal to the beginning of data_region0

.equiv PMP_ADDR1, 0x80002e00  # Should be equal to top range of data_region0

.equiv PMP_ADDR2, 0x80002f00  # Should be equal to top range of data_region1

# PMP config registers contains 4 8-bit configs that consist of:
#   7  6  5 4   3  2   1   0
# | L | 00 |  A  | X | W | R
# with: 
# L (lock), X (execute), W (write), R (read) 
# A matching mode (0-OFF, 1-TOR, 2-NA4, 3-NAPOT)

# Config for this test:
# region0: OFF all rights  -> 0b00001111/0x0F
# region1: OFF all rights  -> 0b00001111/0x0F
# region2: OFF all rights  -> 0b00001111/0x0F
# (this test will fail)
# Note: as stated in the spec - 
#   "If at least one PMP entry is implemented, but all PMP entries’ A
#    fields are set to OFF, then all S-mode and U-mode memory accesses 
#    will fail."

.equiv PMP_CONFIG, 0x00070707

# Note: The 0 bits correspond to the MPP field, responsible 
# of the mode selection (0b00 for U, 0b01 for S and 0b11 for M)
.equiv MASK_MPP_USER_MODE, 0xFFFFE7FF

.global main

.section .text

test_start:
    # Testing region 1 access
    ld a0, 8(s2)
    sd a0, 8(s2)
    # Testing region 2 access
    ld a0, 8(s3)
    sd a0, 8(s3)
    ret

pmp_setup:
    # Read the mode
    csrr t0, mstatus

    # Setup user mode
    li t1, MASK_MPP_USER_MODE
    and t0, t0, t1             # Set MPP to user mode
    or t0, t0, 8               # Set MIE
    csrw mstatus, t0           # Write the value back to the CSR

    # Setup user mode entry address
    la t0, test_start
    csrw mepc, t0

    # Setup first PMP region
    li t0, PMP_ADDR0
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr0, t0

    # Setup second PMP region
    li t0, PMP_ADDR1
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr1, t0

    # Setup third PMP region
    li t0, PMP_ADDR2
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr2, t0

    # Setup PMP config 
    li t0, PMP_CONFIG
    csrw pmpcfg0, t0

    # Jump to the mepc address (test_start)
    mret

    
main:
    la s2, data_region0    # Load the data region 0 address in s2
    la s3, data_region1    #       -              1      -     s3
    call pmp_setup         # Call the generated binary
    li a0, 0               # Pass 0 to the exit function
    call exit              # 

.section .data

data_region0:
    .incbin "data/data.bin"

data_region1:
    .incbin "data/data.bin"