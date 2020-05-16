#!	/bin/bash
make clean
make SCHED_POLICY=MLFQ_SCHED MLFQ_K=2
make SCHED_POLICY=MLFQ_SCHED MLFQ_K=2 fs.img
