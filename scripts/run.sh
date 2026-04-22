#!/bin/bash
# =============================================================================
# run.sh — Jalankan Robot Framework tests lalu generate semua reports.
#
# Usage:
#   ./scripts/run.sh                  → jalankan semua tests (tests/)
#   ./scripts/run.sh tests/ui/        → hanya UI tests
#   ./scripts/run.sh tests/api/       → hanya API tests
#   ./scripts/run.sh tests/ui/test_form_static.robot  → satu file spesifik
#
# Extra options (diteruskan langsung ke robot):
#   ./scripts/run.sh tests/ui/ --include SMOKE
#   ./scripts/run.sh tests/ui/ --variable HEADLESS:True
# =============================================================================

# --- Ambil argument pertama sebagai path, sisanya diteruskan ke robot --------
TEST_PATH="${1:-tests/}"
shift 2>/dev/null   # buang argument pertama, sisanya jadi $@

echo ""
echo "=============================================="
echo " Robot Framework Test Runner"
echo "=============================================="
echo " Target : $TEST_PATH"
echo " Extra  : $@"
echo "=============================================="
echo ""

# --- 1. Jalankan robot -------------------------------------------------------
robot --outputdir results "$TEST_PATH" "$@"
ROBOT_EXIT=$?

echo ""
echo "=============================================="
echo " Generating reports..."
echo "=============================================="

# --- 2. RF Metrics -----------------------------------------------------------
echo ""
echo "[1/2] RF Metrics..."
cd results && robotmetrics && cd ..
echo "      → metrics.html (di folder results/)"

# --- 3. RF Dashboard ---------------------------------------------------------
echo ""
echo "[2/2] RF Dashboard..."
robotdashboard -o results/output.xml
echo "      → robot_dashboard_*.html (di folder project)"

# --- 4. Ringkasan ------------------------------------------------------------
echo ""
echo "=============================================="
echo " Selesai! Reports tersedia di:"
echo "   Built-in  : results/report.html"
echo "   Built-in  : results/log.html"
echo "   RF Metrics: results/metrics.html"
echo "   RF Dashboard: robot_dashboard_*.html"
echo "=============================================="
echo ""

exit $ROBOT_EXIT
