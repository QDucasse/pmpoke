# This test uses three memory regions in TOR, one with full rights,
# containing the .text section, one with read-only for data and another
# data region with no rights. We try to access both data regions
# in M-mode (they should all work):
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


# PMP address registers contains:
#  63   54 53              0
# |   0   |    addr[55:2]   |

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
# region0: locked TOR all rights  -> 0b10001111/0x8F
# region1: locked TOR RO          -> 0b10001001/0x89
# region2: locked TOR no rights   -> 0b10001000/0x88

.equiv PMP_CONFIG, 0x0088898F

.global main

.section .text

test_start:
    # Testing region 1 access (enabled)  -> ok in m mode
    ld a0, 0(s2)
    # Testing region 2 access (disabled) -> ok in m mode
    ld a0, 0(s3)
    ret

pmp_setup:
    # Setup first PMP region
    la t0, data_region0
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr0, t0

    # Setup second PMP region
    la t0, data_region1
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr1, t0

    # Setup PMP config 
    li t0, PMP_CONFIG
    csrw pmpcfg0, 0

    # Directly jump into the test start (no mode change) !
    j test_start
    
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