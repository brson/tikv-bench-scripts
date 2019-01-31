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
cargo bench --lib 2>&1 | tee tikv-1.txt
git checkout $after_commit
cargo bench --lib 2>&1 | tee tikv-2.txt

git checkout $before_commit
cargo bench -p codec 2>&1 | tee codec-1.txt
git checkout $after_commit
cargo bench -p codec 2>&1 | tee codec-2.txt

git checkout $before_commit
cargo bench --bench misc 2>&1 | tee misc-1.txt
git checkout $after_commit
cargo bench --bench misc 2>&1 | tee misc-2.txt

git checkout $before_commit
cargo bench -p test_util 2>&1 | tee test_util-1.txt
git checkout $after_commit
cargo bench -p test_util 2>&1 | tee test_util-2.txt

git checkout $before_commit
cargo bench --bench raftstore -- --save-baseline raftstore-1
git checkout $after_commit
cargo bench --bench raftstore -- --save-baseline raftstore-2

git checkout $before_commit
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-1
git checkout $after_commit
cargo bench --bench coprocessor_executors -- --save-baseline coprocessor_executors-2

git checkout $before_commit
cargo bench --bench hierarchy -- --save-baseline hierarchy-1
git checkout $after_commit
cargo bench --bench hierarchy -- --save-baseline hierarchy-2

