
# gdb requires special privileges to access Mach ports.
# One can either codesign the binary as per https://sourceware.org/gdb/wiki/BuildingOnDarwin
# Or, on 10.12 Sierra or later with SIP, declare `set startup-with-shell off` in `~/.gdbinit`:
grep -qF 'set startup-with-shell off' ~/.gdbinit || echo 'set startup-with-shell off' | tee -a ~/.gdbinit >/dev/null
