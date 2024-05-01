import 'package:flutter/material.dart'; // Mengimpor paket flutter/material yang berisi widget dan fungsi yang diperlukan untuk membangun antarmuka pengguna.
import 'package:http/http.dart'
    as http; // Mengimpor paket http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Mengimpor paket dart:convert untuk mengonversi data dari dan ke format JSON.

void main() {
  runApp(const MyApp()); // Memulai aplikasi dengan menjalankan MyApp().
}

class Activity {
  // Mendefinisikan kelas Activity.
  String aktivitas; // Properti untuk menyimpan nama aktivitas.
  String jenis; // Properti untuk menyimpan jenis aktivitas.

  Activity(
      {required this.aktivitas,
      required this.jenis}); // Konstruktor untuk menginisialisasi properti aktivitas dan jenis.

  factory Activity.fromJson(Map<String, dynamic> json) {
    // Factory constructor untuk membuat objek Activity dari JSON.
    return Activity(
      aktivitas: json['activity'], // Mengambil nilai 'activity' dari JSON.
      jenis: json['type'], // Mengambil nilai 'type' dari JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  // Mendefinisikan kelas MyApp yang merupakan turunan dari StatefulWidget.
  const MyApp({Key? key}) : super(key: key); // Konstruktor MyApp.

  @override
  State<StatefulWidget> createState() {
    // Mengimplementasikan method createState() untuk membuat dan mengembalikan MyAppState.
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // Mendefinisikan kelas MyAppState yang merupakan turunan dari State<MyApp>.
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil future.

  String url =
      "https://www.boredapi.com/api/activity"; // URL untuk permintaan HTTP.

  Future<Activity> init() async {
    // Method untuk menginisialisasi futureActivity.
    return Activity(
        aktivitas: "",
        jenis: ""); // Mengembalikan objek Activity dengan nilai awal.
  }

  Future<Activity> fetchData() async {
    // Method untuk mengambil data dari API.
    final response = await http.get(Uri.parse(
        url)); // Mengirim permintaan HTTP GET ke URL dan menunggu responsenya.
    if (response.statusCode == 200) {
      // Jika responsenya sukses (status code 200),
      return Activity.fromJson(jsonDecode(
          response.body)); // Mengembalikan objek Activity dari respons JSON.
    } else {
      // Jika responsenya tidak sukses,
      throw Exception('Gagal load'); // Melemparkan pengecualian.
    }
  }

  @override
  void initState() {
    // Method initState() untuk menginisialisasi state.
    super.initState();
    futureActivity =
        init(); // Memanggil method init() untuk menginisialisasi futureActivity.
  }

  @override
  Widget build(BuildContext context) {
    // Method build() untuk membangun antarmuka pengguna.
    return MaterialApp(
      // Mengembalikan MaterialApp, yang menyediakan konfigurasi aplikasi.
      home: Scaffold(
        // Mengembalikan Scaffold, sebagai tata letak utama aplikasi.
        body: Center(
          // Widget Center untuk menempatkan konten di tengah layar.
          child: Column(
            // Widget Column untuk menempatkan widget dalam kolom.
            mainAxisAlignment: MainAxisAlignment
                .center, // Menyusun widget secara vertikal di tengah layar.
            children: [
              Padding(
                // Widget Padding untuk menambahkan padding di sekitar widget.
                padding: EdgeInsets.only(
                    bottom: 20), // Menetapkan padding di bagian bawah.
                child: ElevatedButton(
                  // Widget ElevatedButton untuk membuat tombol yang naik ketika ditekan.
                  onPressed: () {
                    // Fungsi yang akan dijalankan ketika tombol ditekan.
                    setState(() {
                      // Memanggil setState() untuk memperbarui tampilan saat tombol ditekan.
                      futureActivity =
                          fetchData(); // Memanggil method fetchData() untuk mengambil data aktivitas baru.
                    });
                  },
                  child: Text(
                      "Saya bosan ..."), // Teks yang ditampilkan pada tombol.
                ),
              ),
              FutureBuilder<Activity>(
                // Widget FutureBuilder untuk membangun UI berdasarkan hasil future.
                future: futureActivity, // Menetapkan future yang akan dipantau.
                builder: (context, snapshot) {
                  // Menggunakan builder untuk membangun UI berdasarkan status future.
                  if (snapshot.hasData) {
                    // Jika future memiliki data,
                    return Center(
                      // Widget Center untuk menempatkan konten di tengah layar.
                      child: Column(
                        // Widget Column untuk menempatkan widget dalam kolom.
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Menyusun widget secara vertikal di tengah layar.
                        children: [
                          Text(snapshot
                              .data!.aktivitas), // Menampilkan nama aktivitas.
                          Text(
                              "Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas.
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Jika terjadi error,
                    return Text(
                        '${snapshot.error}'); // Menampilkan pesan error.
                  }
                  return const CircularProgressIndicator(); // Menampilkan indikator kemajuan saat data masih dimuat.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
