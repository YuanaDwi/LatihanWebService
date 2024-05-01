import 'dart:convert'; // Mengimpor paket dart:convert untuk mengonversi data dari dan ke format JSON.

void main() {
  String jsonTranskrip = '''
  {
    "nama": "Yuana Istiqomah Dwi Koesmawati",
    "npm": "22082010005",
    "program_studi": "Sistem Informasi",
    "mata_kuliah": [
      {
        "kode": "PD1",
        "nama": "Pemrograman Dasar",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "BD1",
        "nama": "Basis Data",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "IMK1",
        "nama": "Interaksi Manusia Komputer",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "PM1",
        "nama": "Pemrograman Mobile",
        "sks": 3,
        "nilai": "A"
      }
    ]
  }
  '''; // Data transkrip akademik dalam format JSON.

  Map<String, dynamic> transkrip = jsonDecode(
      jsonTranskrip); // Mendekode JSON transkrip ke dalam bentuk Map.

  int totalSKS = 0; // Variabel untuk menyimpan total SKS.
  double totalNilai = 0.0; // Variabel untuk menyimpan total nilai.

  // Menghitung total SKS dan total nilai.
  for (var matkul in transkrip['mata_kuliah']) {
    totalSKS += int.parse(matkul['sks'].toString());
    totalNilai +=
        _nilaiToBobot(matkul['nilai']) * int.parse(matkul['sks'].toString());
  }

  double ipk = totalNilai / totalSKS; // Menghitung IPK.

  // Menampilkan informasi transkrip dan IPK.
  print('Nama: ${transkrip['nama']}');
  print('NPM: ${transkrip['npm']}');
  print('Program Studi: ${transkrip['program_studi']}');
  print('IPK: ${ipk.toStringAsFixed(2)}');
}

// Mengonversi nilai huruf ke bobot nilai.
double _nilaiToBobot(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.7;
    case 'B+':
      return 3.3;
    default:
      return 0.0;
  }
}
