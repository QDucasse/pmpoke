# Clock
set commentsSignals [list]
lappend commentsSignals "Clock"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.clock"
set num_added [ gtkwave::addSignalsFromList $sig_list ]

# Instruction and program counter
set commentsSignals [list]
lappend commentsSignals "Inst and PC"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.inst\[31:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pc\[39:0\]"
set num_added [ gtkwave::addSignalsFromList $sig_list ]

# Temp registers
set commentsSignals [list]
lappend commentsSignals "t0 temp register"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.rf(26)\[63:0\]"
set num_added [ gtkwave::addSignalsFromList $sig_list ]

# PMP 0 CSRs
set commentsSignals [list]
lappend commentsSignals "PMP 0"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_addr\[29:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_cfg_a\[1:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_cfg_l"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_cfg_r"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_cfg_w"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_0_cfg_x"
set num_added [ gtkwave::addSignalsFromList $sig_list ]

# PMP 1 CSRs
set commentsSignals [list]
lappend commentsSignals "PMP 1"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_addr\[29:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_cfg_a\[1:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_cfg_l"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_cfg_r"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_cfg_w"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_1_cfg_x"
set num_added [ gtkwave::addSignalsFromList $sig_list ]

# PMP 2 CSRs
set commentsSignals [list]
lappend commentsSignals "PMP 2"
set num_added [ gtkwave::addCommentTracesFromList $commentsSignals ]
set sig_list [list]
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_addr\[29:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_cfg_a\[1:0\]"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_cfg_l"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_cfg_r"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_cfg_w"
lappend sig_list "TOP.TestHarness.ldut.tile_prci_domain.tile_reset_domain_tile.core.csr.io_pmp_2_cfg_x"
set num_added [ gtkwave::addSignalsFromList $sig_list ]
