#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

pass() { ((PASS++)); echo "  ✓ $1"; }
fail() { ((FAIL++)); echo "  ✗ $1"; }

echo "backend-forge smoke tests"
echo "========================="
echo ""

# Test 1: install.sh exists and is executable
echo "install.sh"
[ -f "$SCRIPT_DIR/install.sh" ] && pass "exists" || fail "missing"
[ -x "$SCRIPT_DIR/install.sh" ] && pass "executable" || fail "not executable"

# Test 2: uninstall.sh exists
echo "uninstall.sh"
[ -f "$SCRIPT_DIR/uninstall.sh" ] && pass "exists" || fail "missing"

# Test 3: SKILL.md exists and has frontmatter
echo "SKILL.md"
[ -f "$SCRIPT_DIR/SKILL.md" ] && pass "exists" || fail "missing"
grep -q "name: backend-forge" "$SCRIPT_DIR/SKILL.md" && pass "correct name" || fail "wrong name"
grep -q "SQL Safety" "$SCRIPT_DIR/SKILL.md" && pass "SQL safety section" || fail "SQL safety missing"
grep -q "Rate Limiting" "$SCRIPT_DIR/SKILL.md" && pass "rate limiting section" || fail "rate limiting missing"
grep -q "Audit Logging" "$SCRIPT_DIR/SKILL.md" && pass "audit logging section" || fail "audit logging missing"

# Test 4: state-template.json valid JSON and correct format
echo "state-template.json"
[ -f "$SCRIPT_DIR/state-template.json" ] && pass "exists" || fail "missing"
python3 -c "import json; json.load(open('$SCRIPT_DIR/state-template.json'))" 2>/dev/null && pass "valid JSON" || fail "invalid JSON"
python3 -c "import json; d=json.load(open('$SCRIPT_DIR/state-template.json')); assert isinstance(d['projects'], dict)" 2>/dev/null && pass "projects is object" || fail "projects not object"
! grep -q "access_token" "$SCRIPT_DIR/state-template.json" && pass "no access_token" || fail "access_token found"

# Test 5: schemas exist
echo "schemas/"
[ -f "$SCRIPT_DIR/schemas/commands.schema.json" ] && pass "commands.schema.json exists" || fail "missing"
python3 -c "import json; json.load(open('$SCRIPT_DIR/schemas/commands.schema.json'))" 2>/dev/null && pass "valid JSON" || fail "invalid JSON"

# Test 6: Security files
echo "security"
[ -f "$SCRIPT_DIR/SECURITY.md" ] && pass "SECURITY.md exists" || fail "missing"
[ -f "$SCRIPT_DIR/CHANGELOG.md" ] && pass "CHANGELOG.md exists" || fail "missing"

# Test 7: No secrets in committed files
echo "secret leak check"
! grep -rn --exclude=test.sh "sk_live\|sk_test\|eyJhbG\|AKIA" "$SCRIPT_DIR"/*.md "$SCRIPT_DIR"/*.json "$SCRIPT_DIR"/*.sh 2>/dev/null && pass "no secrets found" || fail "possible secret leak!"

# Test 8: install.sh version check
echo "install.sh features"
grep -q "VERSION=" "$SCRIPT_DIR/install.sh" && pass "version defined" || fail "no version"
grep -q "\-\-force" "$SCRIPT_DIR/install.sh" && pass "--force flag" || fail "no --force flag"
grep -q "chmod 600" "$SCRIPT_DIR/install.sh" && pass "chmod 600 secrets" || fail "no chmod"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "All tests passed!" || exit 1
