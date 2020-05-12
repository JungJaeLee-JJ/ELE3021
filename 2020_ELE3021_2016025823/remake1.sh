#!	/bin/bash
make clean
make SCHED_POLICY=MUL
make SCHED_POLICY=MUL fs.img
