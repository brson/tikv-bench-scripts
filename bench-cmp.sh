set -e
set -x

cargo benchcmp tikv-before.txt tikv-after.txt
cargo benchcmp codec-before.txt codec-after.txt
cargo benchcmp misc-before.txt misc-after.txt
cargo benchcmp test_util-before.txt test_util-after.txt
critcmp raftstore-before raftstore-after
critcmp coprocessor_executors-before coprocessor_executors-after
critcmp hierarchy-before hierarchy-after

