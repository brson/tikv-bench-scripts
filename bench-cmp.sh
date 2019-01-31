set -e
set -x

cargo benchcmp tikv-1.txt tikv-2.txt
cargo benchcmp codec-1.txt codec-2.txt
cargo benchcmp misc-1.txt misc-2.txt
cargo benchcmp test_util-1.txt test_util-2.txt
critcmp raftstore-1 raftstore-2
critcmp coprocessor_executors-1 coprocessor_executors-2
critcmp hierarchy-1 hierarchy-2

