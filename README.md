# DemoQA Robot Framework Boilerplate

Boilerplate lengkap Robot Framework untuk form automation, menggunakan
[https://demoqa.com/automation-practice-form](https://demoqa.com/automation-practice-form) sebagai contoh target.

---

## Struktur Folder

```
DemoQA_Boilerplate/
├── config/
│   └── settings.robot              ← URL, browser, timeout — edit di sini jika ganti project
├── libraries/
│   └── FormHelper.py               ← Python helper untuk element sulit (React-Select, datepicker, autocomplete)
├── resources/
│   ├── keywords/
│   │   └── CommonKeywords.robot    ← Keyword generik (Open Browser, Input, Click, Screenshot)
│   ├── page_objects/
│   │   └── PracticeFormPage.robot  ← Semua locator + keyword khusus halaman form
│   └── testdata/
│       └── form_data.csv           ← Data untuk data-driven test
├── tests/
│   ├── ui/
│   │   ├── test_form_static.robot      ← Test dengan data hardcoded (lebih mudah di-debug)
│   │   └── test_form_datadriven.robot  ← Test dari CSV (bisa banyak data sekaligus)
│   └── api/
│       └── test_bookstore_api.robot    ← Contoh API test (BookStore API)
├── results/                        ← Output otomatis (log.html, report.html, screenshots)
└── requirements.txt
```

---

## Prerequisites

Sebelum mulai, pastikan sudah terinstall:

1. **Python 3.9+** — cek dengan `python --version`
2. **Google Chrome** — browser yang digunakan secara default
3. **pip** — biasanya sudah ada bersama Python

---

## Langkah 1 — Setup Virtual Environment (Recommended)

Buka terminal/command prompt, masuk ke folder ini:

```bash
cd "D:\Personal Project\Robot_Boilerplate\DemoQA_Boilerplate"
```

Buat dan aktifkan virtual environment:

```bash
# Buat venv
python -m venv venv

# Aktifkan (Windows Command Prompt)
venv\Scripts\activate

# Aktifkan (Windows PowerShell)
venv\Scripts\Activate.ps1

# Aktifkan (Git Bash / WSL)
source venv/Scripts/activate
```

Setelah aktif, prompt akan berubah menjadi `(venv) ...`

---

## Langkah 2 — Install Dependencies

```bash
pip install -r requirements.txt
```

Ini akan menginstall:
- `robotframework` — core framework
- `robotframework-seleniumlibrary` — library UI testing
- `selenium` — WebDriver (Selenium 4.6+ sudah include Selenium Manager, tidak perlu download ChromeDriver manual)
- `robotframework-datadriver` — library untuk membaca CSV
- `robotframework-requests` — library untuk API testing

---

## Langkah 3 — Verifikasi Instalasi

```bash
robot --version
```

Output yang diharapkan: `Robot Framework 7.x.x`

---

## Langkah 4 — Jalankan Test

Semua perintah dijalankan dari dalam folder `DemoQA_Boilerplate`.

### Cara 1 — Pakai script (recommended)

Script `scripts/run.sh` menjalankan test **sekaligus** men-generate RF Metrics dan RF Dashboard secara otomatis.

```bash
# Beri permission execute (sekali saja)
chmod +x scripts/run.sh

# Jalankan semua test
./scripts/run.sh

# Hanya UI tests
./scripts/run.sh tests/ui/

# Hanya API tests
./scripts/run.sh tests/api/

# Satu file spesifik
./scripts/run.sh tests/ui/test_form_static.robot

# Dengan extra options (diteruskan ke robot)
./scripts/run.sh tests/ui/ --include SMOKE
./scripts/run.sh tests/ui/ --variable HEADLESS:True
```

Di Windows CMD (bukan Git Bash):
```bat
scripts\run.bat tests\ui\
```

### Cara 2 — Pakai robot langsung (tanpa auto-generate report)

```bash
# Semua UI test
robot --outputdir results tests/ui/

# Semua API test
robot --outputdir results tests/api/

# Semua test
robot --outputdir results tests/

# Filter by tag
robot --include SMOKE --outputdir results tests/
robot --exclude API --outputdir results tests/

# Headless
robot --variable HEADLESS:True --outputdir results tests/ui/
```

---

## Langkah 5 — Lihat Hasil

Setelah test selesai, buka file berikut di browser:

```
results/report.html   ← Ringkasan eksekusi (PASS/FAIL per test case)
results/log.html      ← Detail langkah per langkah + screenshot
```

Jika ada test yang FAIL, screenshot otomatis tersimpan di:

```
results/screenshots/FAIL_<nama_test>_<timestamp>.png
```

---

## Langkah 6 — Custom Report (Opsional)

Dua pilihan report yang lebih visual dari bawaan RF, keduanya cukup `pip install` saja — tidak butuh Java atau Node.js.

### Install

```bash
pip install -r requirements.txt
```

Atau install satu per satu:

```bash
pip install robotframework-metrics==3.7.0
pip install robotframework-dashboard
```

---

### Opsi A — RF Metrics

Menghasilkan satu file HTML statis dengan ringkasan eksekusi, grafik PASS/FAIL, dan breakdown per suite/tag.

**Generate report** (jalankan setelah `robot` selesai):

```bash
robotmetrics --inputpath results/ --output metrics.html
```

`--output` hanya menerima nama file (bukan path). File `metrics.html` akan muncul di folder project saat ini.

**Jalankan test + langsung generate:**

```bash
robot --outputdir results tests/ && robotmetrics --inputpath results/ --output metrics.html
```

---

### Opsi B — RF Dashboard

Menyimpan hasil ke SQLite dan menghasilkan dashboard HTML interaktif. Cocok untuk melihat **trend antar run** (run 1 vs run 2 vs run 3).

**Generate report:**

```bash
robotdashboard -o results/output.xml
```

Hasilnya berupa file `robotdashboard.html` di folder saat ini.

**Jalankan test + langsung generate:**

```bash
robot --outputdir results tests/ && robotdashboard -o results/output.xml
```

---

## Cara Menambah Data Baru (Data-Driven)

Buka file `resources/testdata/form_data.csv`.

Baris pertama adalah header (jangan diubah). Tambah baris baru di bawahnya:

```
*** Test Cases ***,${first_name},${last_name},${email},${gender},${mobile},${dob_day},${dob_month},${dob_year},${subjects},${hobbies},${address},${state},${city}
Data Row 01 - ...,John,Doe,john@test.com,Male,0812345678,15,January,1990,Maths,Sports,Jl. Test No.1,NCR,Delhi
Data Row 02 - ...,Jane,Smith,jane@test.com,Female,0898765432,...
```

**Catatan penting untuk CSV:**

| Kolom | Format | Contoh |
|---|---|---|
| `${gender}` | Tepat seperti label di form | `Male` / `Female` / `Other` |
| `${dob_month}` | Nama bulan penuh (English) | `January`, `February`, dst |
| `${subjects}` | Satu subject, atau beberapa dipisah `;` | `Maths` atau `Maths;English` |
| `${hobbies}` | Satu hobby, atau beberapa dipisah `;` | `Sports` atau `Sports;Music` |
| `${state}` | Harus persis sesuai pilihan di dropdown | `NCR`, `Uttar Pradesh`, `Rajasthan`, `Haryana` |
| `${city}` | Harus sesuai pilihan setelah state dipilih | `Delhi` (jika state = NCR) |

---

## Cara Menggunakan untuk Project Baru

Untuk mengadaptasi boilerplate ini ke form/website lain:

1. **Edit `config/settings.robot`** — ubah `BASE_URL`, `FORM_URL`, dan setting lain sesuai target project baru.

2. **Buat page object baru** di `resources/page_objects/` — duplikat `PracticeFormPage.robot`, ganti nama, update semua locator `${FLD_*}`, `${BTN_*}`, dst.

3. **Update `libraries/FormHelper.py`** jika ada element kompleks baru (dropdown library lain, custom datepicker, dll). Kalau tidak ada element kompleks, file ini tidak perlu diubah.

4. **Buat test file baru** di `tests/ui/` — duplikat salah satu dari test yang sudah ada, ganti Resource ke page object baru, update variabel.

5. **Edit `form_data.csv`** — sesuaikan kolom dengan field form yang baru.

---

## Penjelasan Arsitektur

```
Test Files (.robot)
    └── memanggil keyword dari →
Page Objects (.robot)
    ├── locator disimpan sebagai ${VARIABLE}
    ├── keyword tingkat halaman: Fill Personal Information, Submit Form, dll
    └── memanggil →
        ├── CommonKeywords.robot (generik: Input Text, Click, Screenshot)
        └── FormHelper.py (Python: React-Select, datepicker, autocomplete)
```

Dengan pola ini:
- Kalau locator berubah → edit hanya di page object
- Kalau flow berubah → edit hanya di test file
- Kalau element kompleks (dropdown library) berubah → edit hanya di FormHelper.py

---

## Troubleshooting

**Error: `chromedriver` tidak ditemukan**
Selenium 4.6+ menggunakan Selenium Manager untuk auto-download ChromeDriver.
Pastikan versi Selenium sudah 4.6+ dengan: `pip show selenium`

**Test gagal di langkah "Open Browser"**
Cek apakah Chrome sudah terinstall. Pastikan versi Chrome dan ChromeDriver kompatibel.

**Form tidak terisi / element tidak ditemukan**
Demoqa.com terkadang menampilkan iklan yang menutupi form. Coba:
- Jalankan dengan window lebih besar (`${WINDOW_WIDTH}` di settings.robot)
- Nonaktifkan ekstensi browser
- Coba mode headless: `robot --variable HEADLESS:True ...`

**Test data-driven tidak berjalan / 0 test cases**
Pastikan format CSV benar: baris pertama harus diawali `*** Test Cases ***` dan kolom dipisah koma.

**Screenshot tidak tersimpan**
Folder `results/screenshots` dibuat otomatis. Pastikan robot dijalankan dengan `--outputdir results`.
