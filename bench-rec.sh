# Run and store TiKV benchmarks in a format that can be used by cargo-benchcmp and critcmp

set -x
set -e

befor_dir=tikv2
after_dir=tikv

(cd $befor_dir && (cargo bench --bench misc 2>&1 | tee -a ../misc-before.txt))
(cd $after_dir && (cargo bench --bench misc 2>&1 | tee -a ../misc-after.txt))

(cd $befor_dir && cargo bench --bench raftstore -- --save-baseline raftstore-before)
(cd $after_dir && cargo bench --bench raftstore -- --save-baseline raftstore-after)

(cd $befor_dir && cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-before)
(cd $after_dir && cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-after)

(cd $befor_dir && cargo bench --bench hierarchy -- --save-baseline hierarchy-before)
(cd $after_dir && cargo bench --bench hierarchy -- --save-baseline hierarchy-after)

