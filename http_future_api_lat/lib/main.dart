import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpz;

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Bumi(),
    );
  }
}

class Bumi extends StatefulWidget {
  const Bumi({Key? key}) : super(key: key);

  @override
  State<Bumi> createState() => _BumiState();
}

//bikin variabel user, bentuk list kosong,
//agar semua dataya bisa ditampung
List<Map<String, dynamic>> semuaUser = [];

//bikin vriabel utk handling futurenya dulu
//tipe datanya future
Future dapatSemuaUser() async {
  //mengunggu 5 detik dulu sebelum listtilenya muncul
  // await Future.delayed(Duration(seconds: 5));

  //try, jika berhasil, catch jika gagal
  try {
    var respon =
        await httpz.get(Uri.parse("https://reqres.in/api/users?pages"));

    //list untuk menampilkan semua data
    // json decode utk merubah tipe data dari string menjadi objek
    List dataku = (json.decode(respon.body) as Map<String, dynamic>)["data"];

    //menampilkan semua data user
    // print(dataku);

    //menampilkan email data kedua (index ke-1)
    //print(dataku[1]['email']);

    //menampilkan masing-masing data pengguna dengan foreach
    //agar lebih rapih
    dataku.forEach((element) {
      //menammbahkan data user ke list semuauser
      semuaUser.add(element);

      print(semuaUser);
    });
  } catch (e) {
    print("Terjadi kesalahan");
    print(e); //tampilkan pesan error
  }
}

class _BumiState extends State<Bumi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Future"),
      ),
      body: FutureBuilder(
        //bikin variabel untuk dieksekusi futurenya dulu
        future: dapatSemuaUser(),

        //widget buildernya
        builder: (context, snapshot) {
          //tergantung koneksi internetnya
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Menunggu..."));
          } else {
            //handling kalau di data api nya tidak ada
            if (semuaUser.length == 0) {
              return Center(
                child: Text("Tidak ada data"),
              );
            }

            //kalau ada data apinya, maka muncul data penggunanya
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black26,
                  //url apinya sudah dalam bentuk string
                  backgroundImage:
                      NetworkImage("${semuaUser[index]['avatar']}"),
                ),
                // title: Text("Hahaha"),
                //memanggil masing masing data dengan index ke berapa
                title: Text(
                    "${semuaUser[index]['first_name']} - ${semuaUser[index]['last_name']}"),
                subtitle: Text("{${semuaUser[index]['email']}"),
              ),
              itemCount: semuaUser.length,
            );
          }
        },
      ),
      // body: Center(
      //   child: ElevatedButton(
      //       onPressed: () async {
      //         var respon =
      //             await httpz.get(Uri.parse("https://reqres.in/api/users"));

      //         //error dia enggak mau dalam bentuk list mapping
      //         // List<Map<String, dynamic>> dataz =
      //         //     (json.decode(respon.body) as Map<String, dynamic>)["data"]
      //         //         as List<Map<String, dynamic>>;

      //         //bisa kedalam bentuk list dynamic (semua data)
      //         List dataz =
      //             (json.decode(respon.body) as Map<String, dynamic>)["data"];

      //         print(dataz); //semua data ditampilkan

      //         print(dataz[2]); //hanya data index ke 2 yang muncul.

      //         print(dataz[2]['email']); //memunculkan email index ke2

      //         //untuk ngelooping data sesuai banyaknya data
      //         //lebih rapih dan terstruktur
      //         //ini untuk masing masing data (dalam bentuk foreach / setiap)
      //         dataz.forEach((element) {
      //           //bikin data tipe mapping string dynamic
      //           //element itu per satuan data yang diterima
      //           Map<String, dynamic> peruser = element;

      //           //menampikan semua data dynamic pengguna
      //           print(peruser);

      //           print(peruser["last_name"]);

      //           //manggilnya tidak bisa begini, karena variabel peruser dalam
      //           //bentuk foreach, bukan dalam bentuk list,hasilnya null
      //           //print(peruser[2]["avatar"]);

      //           print(peruser["avatar"]);
      //         });
      //       },
      //       child: Text("Future Builder")),
      // ),
    );
  }
}
