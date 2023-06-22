# This test uses three memory regions in TOR, one with full rights,
# containing the .text section, one with read-only for data and another
# data region with no rights. We try to access both data regions
# in U-mode (the first access should work and the second should not):
# 
# ___________ Region 0 (RWX) _____________
#
#           Code (.text section)
# ________________________________________ < TOR (beginning address data region 0)
# ___________ Region 1 (R__) _____________
#
#             Data region 0
# ________________________________________ < TOR (end address data region 0)
# ___________ Region 2 (___) _____________
#
#             Data region 1
# ________________________________________ < TOR (end address data region 1)



# Note: The 0 bits correspond to the MPP field, responsible 
# of the mode selection (0b00 for U, 0b01 for S and 0b11 for M)
.equiv MASK_MPP_USER_MODE, 0xFFFFE7FF

# PMP address registers contains:
#  63   54 53              0
# |   0   |    addr[55:2]   |

.equiv PMP_ADDR0, 0x80002d00  # Should be equal to the beginning of data_region0 (top range of code)

.equiv PMP_ADDR1, 0x80002e00  # Should be equal to top range of data_region0

.equiv PMP_ADDR2, 0x80002f00  # Should be equal to top range of data_region1

# PMP config registers contains 4 8-bit configs that consist of:
#   7  6  5 4   3  2   1   0
# | L | 00 |  A  | X | W | R
# with: 
# L (lock), X (execute), W (write), R (read) 
# A matching mode (0b00-OFF, 0b01-TOR, 0b10-NA4, 0b11-NAPOT)

# Config for this test:
# region0: locked TOR all rights  -> 0b10001111/0x8F
# region1: locked TOR RO          -> 0b10001001/0x89
# region2: locked TOR no rights   -> 0b10001000/0x88

.equiv PMP_CONFIG, 0x0088898F

.global main

.section .text

test_start:
    # Testing region 1 access (enabled)  -> ok in u mode
    ld a0, 8(s2)
    # Testing region 2 access (disabled) -> ko in u mode
    ld a0, 8(s3)
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