## PMPoke: Testing the PMP

Small ASM tests for the RISC-V Physical Memory Protection unit, using the Rocket CPU and its emulator.


### Installation

To build and run the different tests, a RISC-V toolchain installation is needed as well as the [Rocket](https://github.com/chipsalliance/rocket-chip) verilator emulator:
```bash
export RISCV=/path/to/the/toolchain
export ROCKET=/path/to/rocket/repo
```

You can then build the `elf`/`dump`/`rocket log` using:

```bash
make bin/<test_name>.elf|dump|rocket
```

For `mmode_tor2` for example:

```bash
make bin/mmode_tor2.rocket
```

> Note: Intermediate files are deleted by make as the makefile does not explicitely state them..... I'd rather not expand the makefile and specify the needed intermediate file through make directly if needed, (*e.g.* `make bin/mmode_tor2.elf` to access the `elf` file, etc.). If you want to keep all intermediate files, I found that replacing `%` in the following snippets with the actual name will keep them (needs to be duplicated for each new test though 🥱)

> ```make
> bin/%.elf: $(COMS_O) $(bin_dir)/%.o
> 	$(RISCV_GCC) $(RISCV_LINK_OPTS) $^ -o $@
> ```

### Test memory layout

The tests workflow is the following:
- `main`: that stores the `data_region0` address in `s2` and `data_region1` in `s3`
- `pmp_setup`: that fills the `pmpaddri` and `pmpcfgi` registers in M-mode
- `test_start`: that tries to access memory (either in U-mode or M-mode)

The different `data_regioni` contain the same `data.bin`, a 256-word iteration (0x00000000, 0x00000001, ...). They are `0x100` aligned and usually end up at `0x80000d00`, `0x0x80000e00`, etc. (this can be checked in the dumps!)