import 'package:flutter/material.dart'; // Mengimpor paket flutter/material yang berisi widget dan fungsi yang diperlukan untuk membangun antarmuka pengguna.

import 'package:http/http.dart'
    as http; // Mengimpor paket http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Mengimpor paket dart:convert untuk mengonversi data dari dan ke format JSON.

class University {
  // Mendefinisikan kelas University.
  String name; // Membuat properti String bernama name.
  String website; // Membuat properti String bernama website.

  University(
      {required this.name,
      required this.website}); // Membuat konstruktor yang menginisialisasi properti name dan website.

  factory University.fromJson(Map<String, dynamic> json) {
    // Membuat factory constructor untuk membuat objek University dari data JSON.
    return University(
      name: json['name'], // Mengambil nilai 'name' dari objek JSON.
      website: json['web_pages']
          [0], // Mengambil nilai 'web_pages' indeks ke-0 dari objek JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  // Mendefinisikan kelas MyApp yang merupakan turunan dari StatefulWidget.
  @override
  State<StatefulWidget> createState() {
    // Mendefinisikan method createState() yang mengembalikan MyAppState.
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // Mendefinisikan kelas MyAppState yang merupakan turunan dari State<MyApp>.
  late Future<List<University>>
      futureUniversities; // Membuat variabel futureUniversities yang akan menyimpan hasil dari future fetchData().

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // Mendefinisikan URL endpoint untuk permintaan HTTP.

  Future<List<University>> fetchData() async {
    // Mendefinisikan method fetchData() yang mengembalikan Future<List<University>>.
    final response = await http.get(Uri.parse(
        url)); // Mengirim permintaan HTTP GET ke URL dan menunggu responsenya.

    if (response.statusCode == 200) {
      // Jika responsenya sukses (status code 200),
      List<dynamic> data = jsonDecode(
          response.body); // Mendekodekan respons JSON ke dalam List<dynamic>.
      List<University> universities = data
          .map((json) => University.fromJson(json))
          .toList(); // Mengonversi setiap elemen JSON menjadi objek University dan menyimpannya dalam List<University>.
      return universities; // Mengembalikan list universitas.
    } else {
      // Jika responsenya tidak sukses,
      throw Exception(
          'Failed to load universities'); // Melemparkan pengecualian dengan pesan kesalahan.
    }
  }

  @override
  void initState() {
    // Mendefinisikan method initState() yang akan dijalankan saat widget diinisialisasi.
    super.initState();
    futureUniversities =
        fetchData(); // Memuat data universitas saat widget diinisialisasi.
  }

  @override
  Widget build(BuildContext context) {
    // Mendefinisikan method build() yang mengembalikan widget yang akan dibangun.
    return MaterialApp(
      // Mengembalikan MaterialApp, yang menyediakan konfigurasi aplikasi.
      title: 'List Universitas', // Menetapkan judul aplikasi.
      home: Scaffold(
        // Menetapkan Scaffold sebagai tata letak dasar aplikasi.
        appBar: AppBar(
          // Menetapkan AppBar untuk tampilan bar atas.
          title: Text('List Universitas'), // Menetapkan judul AppBar.
        ),
        body: Center(
          // Mengatur konten aplikasi di tengah layar.
          child: FutureBuilder<List<University>>(
            // Menggunakan FutureBuilder untuk membangun UI berdasarkan hasil future.
            future: futureUniversities, // Menetapkan future yang akan dipantau.
            builder: (context, snapshot) {
              // Mendefinisikan builder untuk membangun widget berdasarkan status future.
              if (snapshot.hasData) {
                // Jika future telah memiliki data,
                return ListView.builder(
                  // Menggunakan ListView.builder untuk membuat daftar berbasis item.
                  itemCount: snapshot.data!
                      .length, // Menetapkan jumlah item dalam daftar sesuai dengan panjang data.
                  itemBuilder: (context, index) {
                    // Mendefinisikan itemBuilder untuk mengonstruksi item daftar.
                    return ListTile(
                      // Membuat ListTile untuk setiap item dalam daftar.
                      title: Text(snapshot.data![index]
                          .name), // Menetapkan judul ListTile sesuai dengan nama universitas.
                      subtitle: Text(snapshot.data![index]
                          .website), // Menetapkan subjudul ListTile sesuai dengan website universitas.
                      onTap:
                          () {}, // Menetapkan fungsi kosong untuk menangani ketika item daftar disentuh.
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika future mengalami kesalahan,
                return Text(
                    '${snapshot.error}'); // Menampilkan pesan kesalahan.
              }
              return CircularProgressIndicator(); // Menampilkan indikator kemajuan saat data masih dimuat.
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  // Mendefinisikan method main() yang akan dijalankan saat aplikasi dijalankan.
  runApp(MyApp()); // Memulai aplikasi Flutter dengan menjalankan MyApp().
}
