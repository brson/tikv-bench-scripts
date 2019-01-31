# Runs and store TiKV benchmarks in a format that can be used by
# [cargo-benchcmp] and [critcmp].
#
# [cargo-benchcmp]: https://github.com/BurntSushi/cargo-benchcmp
# [critcmp]: https://github.com/BurntSushi/critcmp
#
# From your cargo project directory:
#
# bench-cmp.sh $before-commit $after-commit
#
# It will modify your git workspace, so make sure it's committed and
# clean.
#
# For #[bench] benchmarks, this script will save the output
# in .txt files in the current directory. For criterion benchmarks,
# it will save "baselines" in the `target` directory.
#
# Run bench-cmp.sh afterward to get a comparison report.

set -e
set -x

if [[ $1 == "" || $2 == "" ]]; then
	echo "usage: bench-rec.sh $before-commit $after-commit"
	exit 1
fi
	
before_commit="$1"
after_commit="$2"

git checkout $before_commit
cargo bench --lib 2>&1 | tee tikv-before.txt
git checkout $after_commit
cargo bench --lib 2>&1 | tee tikv-after.txt

git checkout $before_commit
cargo bench -p codec 2>&1 | tee codec-before.txt
git checkout $after_commit
cargo bench -p codec 2>&1 | tee codec-after.txt

git checkout $before_commit
cargo bench --bench misc 2>&1 | tee misc-before.txt
git checkout $after_commit
cargo bench --bench misc 2>&1 | tee misc-after.txt

git checkout $before_commit
cargo bench -p test_util 2>&1 | tee test_util-before.txt
git checkout $after_commit
cargo bench -p test_util 2>&1 | tee test_util-after.txt

git checkout $before_commit
cargo bench --bench raftstore -- --save-baseline raftstore-before
git checkout $after_commit
cargo bench --bench raftstore -- --save-baseline raftstore-after

git checkout $before_commit
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-before
git checkout $after_commit
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-after

git checkout $before_commit
cargo bench --bench hierarchy -- --save-baseline hierarchy-before
git checkout $after_commit
cargo bench --bench hierarchy -- --save-baseline hierarchy-after

