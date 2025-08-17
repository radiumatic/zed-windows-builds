#!/bin/bash

# Test script for prepare-release.sh
# This script creates various test scenarios and verifies the behavior

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(mktemp -d)"
PREPARE_SCRIPT="$SCRIPT_DIR/prepare-release.sh"

echo "Running tests in: $TEST_DIR"
cd "$TEST_DIR"

# Test helper functions
setup_test() {
    local test_name="$1"
    echo "🧪 Testing: $test_name"
    rm -rf artifacts release 2>/dev/null || true
    mkdir -p artifacts
}

create_gles_artifact() {
    mkdir -p artifacts/zed-linux-gles
    echo "fake gles executable" > artifacts/zed-linux-gles/zed
}

verify_file_exists() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "❌ FAIL: Expected file $file does not exist"
        return 1
    fi
    echo "✅ File exists: $file"
}

verify_file_count() {
    local expected="$1"
    local actual=$(ls -1 release/ | wc -l)
    if [ "$actual" -ne "$expected" ]; then
        echo "❌ FAIL: Expected $expected files, got $actual"
        ls -la release/
        return 1
    fi
    echo "✅ Correct file count: $expected"
}

run_test() {
    local expected_result="$1"
    if [ "$expected_result" = "success" ]; then
        if "$PREPARE_SCRIPT"; then
            echo "✅ Script succeeded as expected"
        else
            echo "❌ FAIL: Script failed but should have succeeded"
            return 1
        fi
    else
        if "$PREPARE_SCRIPT"; then
            echo "❌ FAIL: Script succeeded but should have failed"
            return 1
        else
            echo "✅ Script failed as expected"
        fi
    fi
}

# Test 1: GLES build exists
setup_test "GLES build exists"
create_gles_artifact
run_test "success"
verify_file_count 3  # zed, zed-linux-gles.zip, sha256sums.txt
verify_file_exists "release/zed"
verify_file_exists "release/zed-linux-gles.zip"
verify_file_exists "release/sha256sums.txt"

# Test 2: No builds exist
setup_test "No builds exist"
run_test "failure"
# Should have no release directory or empty release directory
if [ -d "release" ] && [ "$(ls -A release)" ]; then
    echo "❌ FAIL: Release directory should be empty when no builds exist"
    ls -la release/
    exit 1
fi
echo "✅ No release files created when no builds exist"

# Test 3: Verify checksums are correct
setup_test "Checksum verification"
create_gles_artifact
run_test "success"

# Verify checksums
cd release
if sha256sum -c sha256sums.txt >/dev/null 2>&1; then
    echo "✅ Checksums are valid"
else
    echo "❌ FAIL: Checksums are invalid"
    exit 1
fi
cd ..

# Test 4: Verify zip files contain executables
setup_test "Zip file content verification"
create_gles_artifact
run_test "success"

# Check zip content
if unzip -l release/zed-linux-gles.zip | grep -q "zed"; then
    echo "✅ Zip file contains executable"
else
    echo "❌ FAIL: Zip file does not contain executable"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🎉 All tests passed!"
echo "The prepare-release.sh script works correctly in all scenarios."
