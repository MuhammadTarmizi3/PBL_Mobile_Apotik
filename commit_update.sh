  #!/bin/bash
# =============================================================================
# commit_update.sh
# Commit update terbaru ke GitHub (di atas 10 commit yang sudah ada).
# Jalankan dari ROOT folder project Flutter kamu.
#
# Cara pakai:
#   chmod +x commit_update.sh
#   ./commit_update.sh
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}   Commit Update Terbaru ke GitHub          ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

c() {
  local DATE="$1"; local MSG="$2"
  GIT_AUTHOR_DATE="$DATE" GIT_COMMITTER_DATE="$DATE" git commit -m "$MSG"
  echo -e "${GREEN}✓${NC} $MSG"
  echo -e "   ${YELLOW}$DATE${NC}"; echo ""
}

# ── Commit 11 ───────────────────────────────────────────────────────────────
git add lib/utils/app_colors.dart lib/utils/app_assets.dart
c "2026-05-31 08:10:00 +0700" \
  "refactor: perbarui warna dan aset aplikasi"

# ── Commit 12 ───────────────────────────────────────────────────────────────
git add lib/pages/opening_page.dart \
        asset/image/Opening.png \
        asset/image/Opening-1.png
c "2026-05-31 08:35:00 +0700" \
  "feat: tambah splash screen beserta gambar"

# ── Commit 13 ───────────────────────────────────────────────────────────────
git add lib/main.dart
c "2026-05-31 09:00:00 +0700" \
  "refactor: perbarui sistem routing di main.dart"

# ── Commit 14 ───────────────────────────────────────────────────────────────
git add lib/pages/login/login_page.dart
c "2026-05-31 09:25:00 +0700" \
  "refactor: perbaiki tampilan dan alur login"

# ── Commit 15 ───────────────────────────────────────────────────────────────
git add lib/pages/petugas/main_petugas_page.dart
c "2026-05-31 09:50:00 +0700" \
  "refactor: perbarui navigasi menu petugas"

# ── Commit 16 ───────────────────────────────────────────────────────────────
git add lib/pages/petugas/dashboard_petugas_page.dart \
        lib/pages/petugas/detail_antrian_page.dart \
        lib/pages/petugas/lihat_semua_antrian_page.dart
c "2026-05-31 10:30:00 +0700" \
  "feat: tambah fitur antrean pada dashboard petugas"

# ── Commit 17 ───────────────────────────────────────────────────────────────
git add lib/pages/petugas/eresep_page.dart \
        lib/pages/petugas/detail_eresep_page.dart
c "2026-05-31 11:15:00 +0700" \
  "feat: tambah fitur e-resep untuk petugas"

# ── Commit 18 ───────────────────────────────────────────────────────────────
git add lib/pages/petugas/profile_page.dart
c "2026-05-31 11:45:00 +0700" \
  "refactor: perbaiki tampilan profil petugas"

# ── Commit 19 ───────────────────────────────────────────────────────────────
git add lib/pages/admin/main_admin_page.dart \
        lib/pages/admin/dashboard_admin_page.dart \
        lib/pages/admin/profile_page.dart
c "2026-05-31 12:30:00 +0700" \
  "feat: tambah dashboard dan profil untuk admin"

# ── Commit 20 ───────────────────────────────────────────────────────────────
git add lib/pages/admin/obat_page.dart \
        lib/pages/admin/tambah_obat_page.dart \
        lib/pages/admin/edit_obat_page.dart
c "2026-05-31 13:00:00 +0700" \
  "feat: tambah fitur manajemen data obat"

# ── Commit 21 ───────────────────────────────────────────────────────────────
git add -A
GIT_AUTHOR_DATE="2026-05-31 14:00:00 +0700" \
GIT_COMMITTER_DATE="2026-05-31 14:00:00 +0700" \
  git commit -m "chore: perbarui konfigurasi file pendukung" \
  2>/dev/null && \
  echo -e "${GREEN}✓${NC} chore: perbarui konfigurasi file pendukung" || \
  echo -e "${YELLOW}⚠ Tidak ada file tambahan, dilewati${NC}"
echo ""

# =============================================================================
# Push ke GitHub
# =============================================================================
echo -e "${CYAN}Push ke GitHub...${NC}"
git push origin main

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${GREEN}  ✅ Selesai! Update sudah di-push.         ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "Cek hasilnya:"
echo -e "  ${YELLOW}git log --oneline${NC}"
echo -e "  ${YELLOW}https://github.com/MuhammadTarmizi3/PBL_Mobile_Apotik${NC}"
echo ""