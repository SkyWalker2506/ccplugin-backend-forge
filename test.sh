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

# Test 9: Schema structure validation
echo "schema structure"
python3 -c "
import json, sys
s = json.load(open('$SCRIPT_DIR/schemas/commands.schema.json'))
cmds = ['create_project','deploy','db_exec','db_schema','auth_setup','env_set','storage_create','status','destroy']
for c in cmds:
    assert c in s['definitions'], f'{c} missing from schema'
" 2>/dev/null && pass "all commands in schema" || fail "missing commands in schema"

# Test 10: state.schema.json validation
echo "state.schema.json"
[ -f "$SCRIPT_DIR/schemas/state.schema.json" ] && pass "exists" || fail "missing"
python3 -c "import json; json.load(open('$SCRIPT_DIR/schemas/state.schema.json'))" 2>/dev/null && pass "valid JSON" || fail "invalid JSON"

# Test 11: state-template matches v2 spec
echo "state-template v2"
python3 -c "
import json
d = json.load(open('$SCRIPT_DIR/state-template.json'))
assert d.get('version') == '2', 'version not 2'
assert '_rate' in d, '_rate missing'
assert '_telemetry' in d, '_telemetry missing'
assert d.get('preferences',{}).get('telemetry') == False, 'telemetry pref missing'
" 2>/dev/null && pass "v2 fields present" || fail "v2 fields missing"

# Test 12: VERSION file
echo "VERSION file"
[ -f "$SCRIPT_DIR/VERSION" ] && pass "exists" || fail "missing"
grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' "$SCRIPT_DIR/VERSION" 2>/dev/null && pass "semver format" || fail "invalid semver"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "All tests passed!" || exit 1
