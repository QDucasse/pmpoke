# Derived from mmode.S

# This test uses three memory regions in TOR, one with full rights,
# containing the .text section, one with read-only for data and another
# data region with no rights. We try to access both data regions
# in M-mode (they should all work):
#
# ___________ Region 0 (RWX) _____________
#
#           Code (.text section)
# ________________________________________ < TOR (beginning address data region 0)
# ___________ Region 1 (R__) _____________ < NAPOT (first 32 bytes of data region 1)
#
#             Data region 0
# ________________________________________ 
# ___________ Region 2 (___) _____________ < NAPOT (first 32 bytes of data region 1)
#
#             Data region 1
# ________________________________________


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
# A matching mode (0-OFF, 1-TOR, 2-NA4, 3-NAPOT)

# Config for this test:
# region0: locked TOR all rights  -> 0b10001111/0x8F
# region1: locked NAPOT RO        -> 0b10011001/0x99
# region2: locked NAPOT RO        -> 0b10011000/0x99

.equiv PMP_CONFIG, 0x0099998F

.global main

.section .text

test_start:
    # Testing region 1 access (enabled)  -> ok in u mode (in the 32 bytes range!)
    ld a0, 8(s2)
    # Testing region 2 access (emabled) ->  ok in u mode (in the 32 bytes range!)
    ld a0, 8(s3)
    # Testing region 2 access (emabled) ->  ko in u mode (outside the 32 bytes range!)
    ld a0, 40(s3)
    ret

pmp_setup:
    # Setup first PMP region
    la t0, data_region0
    srli t0, t0, 2    # Note: addr should be shifted by 2
    csrw pmpaddr0, t0

    # Setup second PMP region
    li t0, PMP_ADDR1
    srli t0, t0, 2    # Note: addr should be shifted by 2
    ori t0, t0, 3     # 32 bytes range
    csrw pmpaddr1, t0

    # Setup third PMP region
    li t0, PMP_ADDR2
    srli t0, t0, 2    # Note: addr should be shifted by 2
    ori t0, t0, 3     # 32 bytes range
    csrw pmpaddr2, t0


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