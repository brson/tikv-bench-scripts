# Run and store TiKV benchmarks in a format that can be used by cargo-benchcmp and critcmp

set -e
set -x

before_commit=1f43235e09045d3d31bcc9730ce017204e717663
after_commit=72bc513d

git checkout $before_commit
cargo bench --no-run -p test_util
cargo bench --no-run --lib tikv
cargo bench --no-run --bench misc
cargo bench --no-run --bench raftstore
cargo bench --no-run --bench coprocessor_executors
cargo bench --no-run --bench hierarchy

cargo bench -p test_util 2>&1 | tee -a test_util-before.txt
cargo bench --lib tikv 2>&1 | tee -a tikv-before.txt
cargo bench --bench misc 2>&1 | tee -a misc-before.txt
cargo bench --bench raftstore -- --save-baseline raftstore-before
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-before
cargo bench --bench hierarchy -- --save-baseline hierarchy-before

git checkout $after_commit
cargo bench --no-run -p test_util
cargo bench --no-run --lib tikv
cargo bench --no-run --bench misc
cargo bench --no-run --bench coprocessor_executors
cargo bench --no-run --bench hierarchy

cargo bench -p test_util 2>&1 | tee -a test_util-after.txt
cargo bench --lib tikv 2>&1 | tee -a tikv-after.txt
cargo bench --bench misc 2>&1 | tee -a misc-after.txt
cargo bench --bench raftstore -- --save-baseline raftstore-after
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-after
cargo bench --bench hierarchy -- --save-baseline hierarchy-after
