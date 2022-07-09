// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:passify/constant/color_constant.dart';

class DialogHelper {
  static showLoading() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetPlatform.isIOS
                  ? CupertinoActivityIndicator(radius: 20)
                  : SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primaryColor),
                      ),
                    ),
              SizedBox(height: 30),
              Text(
                'Mohon Tunggu...',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static showError({String? title, String? description}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title ?? 'Terdapat Gangguan',
                  style: Get.textTheme.headline6),
              SizedBox(
                height: 10,
              ),
              Text(
                description ?? 'Sorry, something went wrong',
                style: Get.textTheme.bodyText1,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  child: Text('Okay'))
            ],
          ),
        ),
      ),
    );
  }

  static showSuccess({String? title, String? description}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Pemberitahuan',
                style: Get.textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/images/login_illustration.png"),
              ),
              Text(
                description ?? 'COOMING SOON',
                style: Get.textTheme.headline5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  child: Text('Okay'))
            ],
          ),
        ),
      ),
    );
  }

  static showInfo({String? title, String? description}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Informasi Aplikasi',
                style: Get.textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset("assets/images/logo.png", height: 150),
              ),
              Text(
                description ?? 'App Version : v$version',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                description ?? 'App Name : $appName',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
              Text(
                description ?? 'Package Name : $packageName',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  child: Text('Okay'))
            ],
          ),
        ),
      ),
    );
  }

  static showPrivacyPolicy({String? title, String? description}) async {
    String privacy =
        "<!DOCTYPE html><html> <head> <meta charset='utf-8'> <meta name='viewport' content='width=device-width'> <title> </title><style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style></head><body><p>                   Seov Design &amp; Technology membangun aplikasi Passify sebagai aplikasi Gratis. LAYANAN ini disediakan oleh Seov Design &amp; Technology tanpa biaya dan dimaksudkan untuk digunakan apa adanya.</p> <p>                   Halaman ini digunakan untuk memberi tahu pengunjung mengenai kebijakan saya dengan pengumpulan, penggunaan, dan pengungkapan Informasi Pribadi jika ada yang memutuskan untuk menggunakan Layanan saya. </p> <p> Jika Anda memilih untuk menggunakan Layanan saya, maka Anda menyetujui pengumpulan dan penggunaan informasi sehubungan dengan kebijakan ini. Informasi Pribadi yang saya kumpulkan digunakan untuk menyediakan dan meningkatkan Layanan. Konten buatan pengguna adalah konten yang disumbangkan pengguna ke aplikasi, dan yang dapat dilihat atau diakses oleh setidaknya sebagian pengguna aplikasi. Ini termasuk, namun tidak terbatas pada: profil pengguna, komentar, media, postingan, dll.</p><p><b>Konten apa yang tidak diizinkan.</b></p><p>Anda tidak boleh memposting Konten yang melanggar hukum, menyinggung, mengancam, mencemarkan nama baik, memfitnah, cabul atau tidak menyenangkan, atau Konten yang melanggar salah satu dari Ketentuan ini ('Konten Ofensif').</p><p>Contoh Konten Menyinggung tersebut termasuk , namun tidak terbatas pada hal berikut:</p><ul><li><p><b>Pelecehan, pelecehan, ancaman, pembakaran atau intimidasi terhadap orang atau organisasi mana pun,</b></p></li><li><p><b>Terlibat dalam atau berkontribusi pada aktivitas atau aktivitas ilegal apa pun yang melanggar hak orang lain,</b></p></li><li><p><b>Penggunaan bahasa yang menghina, diskriminatif, atau terlalu vulgar, dan</b></p></li><li><p><b>Memberikan informasi yang salah, menyesatkan atau tidak akurat</b></p></li></ul> <p>                   Istilah yang digunakan dalam Kebijakan Privasi ini memiliki arti yang sama seperti dalam Syarat dan Ketentuan kami, yang dapat diakses di Passify kecuali ditentukan lain dalam Kebijakan Privasi ini.</p> <p><strong>Pengumpulan dan Penggunaan Informasi</strong></p> <p>                   Untuk pengalaman yang lebih baik, saat menggunakan Layanan kami, saya mungkin meminta Anda untuk memberikan kami informasi pengenal pribadi tertentu, termasuk namun tidak terbatas pada Desain & Teknologi Seov. Konten buatan pengguna adalah konten yang disumbangkan pengguna ke aplikasi, dan yang dapat dilihat atau diakses oleh setidaknya sebagian pengguna aplikasi. Ini termasuk, namun tidak terbatas pada: profil pengguna, komentar, media, postingan, dll.</p><p>Aplikasi ini menggunakan layanan pihak ketiga yang dapat mengumpulkan informasi yang digunakan untuk mengidentifikasi Anda.</p><p>Tautan ke kebijakan privasi penyedia layanan pihak ketiga yang digunakan oleh aplikasi</p><ul><li><a rel='nofollow' target='_blank' href='https://www.google.com/policies/privacy/'>Google Play Services</a></li><li><a rel='nofollow' target='_blank' href='https://firebase.google.com/policies/analytics'>Google Analytics for Firebase</a></li></ul> <p><strong>Log Data</strong></p> <p>                   Saya ingin memberi tahu Anda bahwa setiap kali Anda menggunakan Layanan saya, jika terjadi kesalahan dalam aplikasi, saya mengumpulkan data dan informasi (melalui produk pihak ketiga) di ponsel Anda yang disebut Data Log. Data Log ini dapat mencakup informasi seperti alamat Protokol Internet (“IP”) perangkat Anda, nama perangkat, versi sistem operasi, konfigurasi aplikasi saat menggunakan Layanan saya, waktu dan tanggal penggunaan Layanan oleh Anda, dan statistik lainnya .</p> <p><strong>Cookies</strong></p> <p>                   Cookie adalah file dengan sejumlah kecil data yang biasanya digunakan sebagai pengidentifikasi unik anonim. Ini dikirim ke browser Anda dari situs web yang Anda kunjungi dan disimpan di memori internal perangkat Anda.                 </p> <p>                   Layanan ini tidak menggunakan 'cookies' ini secara eksplisit. Namun, aplikasi dapat menggunakan kode dan perpustakaan pihak ketiga yang menggunakan 'cookies' untuk mengumpulkan informasi dan meningkatkan layanan mereka. Anda memiliki pilihan untuk menerima atau menolak cookie ini dan mengetahui kapan cookie dikirim ke perangkat Anda. Jika Anda memilih untuk menolak cookie kami, Anda mungkin tidak dapat menggunakan beberapa bagian dari Layanan ini.                 </p> <p><strong>Penyedia jasa</strong></p> <p>                   Saya dapat mempekerjakan perusahaan dan individu pihak ketiga karena alasan berikut:                </p> <ul><li>Untuk memfasilitasi Layanan kami;</li> <li>Untuk menyediakan Layanan atas nama kami;</li> <li>Untuk melakukan layanan terkait Layanan; atau</li> <li>Untuk membantu kami dalam menganalisis bagaimana Layanan kami digunakan.</li></ul> <p>                   Saya ingin memberi tahu pengguna Layanan ini bahwa pihak ketiga ini memiliki akses ke Informasi Pribadi mereka. Alasannya adalah untuk melakukan tugas yang diberikan kepada mereka atas nama kita. Namun, mereka berkewajiban untuk tidak mengungkapkan atau menggunakan informasi tersebut untuk tujuan lain.</p> <p><strong>Keamanan</strong></p> <p>                   Saya menghargai kepercayaan Anda dalam memberikan Informasi Pribadi Anda kepada kami, oleh karena itu kami berusaha untuk menggunakan cara yang dapat diterima secara komersial untuk melindunginya. Tetapi ingat bahwa tidak ada metode transmisi melalui internet, atau metode penyimpanan elektronik yang 100% aman dan andal, dan saya tidak dapat menjamin keamanan mutlaknya.              </p> <p><strong>Tautan ke Situs Lain</strong></p> <p>                   Layanan ini mungkin berisi tautan ke situs lain. Jika Anda mengklik tautan pihak ketiga, Anda akan diarahkan ke situs itu. Perhatikan bahwa situs eksternal ini tidak dioperasikan oleh saya. Oleh karena itu, saya sangat menyarankan Anda untuk meninjau Kebijakan Privasi situs web ini. Saya tidak memiliki kendali atas dan tidak bertanggung jawab atas konten, kebijakan privasi, atau praktik dari situs atau layanan pihak ketiga mana pun.               </p> <p><strong>Privasi Anak-anak</strong></p> <div><p>                    Layanan ini tidak ditujukan kepada siapa pun yang berusia di bawah 13 tahun. Saya tidak dengan sengaja mengumpulkan informasi pengenal pribadi dari anak-anak di bawah 13 tahun. Jika saya menemukan bahwa seorang anak di bawah 13 tahun telah memberi saya informasi pribadi, saya segera menghapusnya dari server kami. Jika Anda adalah orang tua atau wali dan Anda mengetahui bahwa anak Anda telah memberikan informasi pribadi kepada kami, silakan hubungi saya sehingga saya dapat melakukan tindakan yang diperlukan.                 </p></div>  <p><strong>Perubahan pada Kebijakan Privasi Ini</strong></p> <p>                 Saya dapat memperbarui Kebijakan Privasi kami dari waktu ke waktu. Oleh karena itu, Anda disarankan untuk meninjau halaman ini secara berkala untuk setiap perubahan. Saya akan memberi tahu Anda tentang perubahan apa pun dengan memposting Kebijakan Privasi baru di halaman ini. </p> <p>Kebijakan ini berlaku mulai 2022-06-22</p> <p><strong>Hubungi kami</strong></p> <p>                  Jika Anda memiliki pertanyaan atau saran tentang Kebijakan Privasi saya, jangan ragu untuk menghubungi saya di seov.detech@gmail.com.</p>     </body></html>";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: Get.height * 0.8,
          width: Get.width * 0.95,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Kebijakan Privasi',
                  style: Get.textTheme.headline6,
                ),
                SizedBox(height: 20),
                Expanded(
                    child: Scrollbar(
                        child:
                            SingleChildScrollView(child: HtmlWidget(privacy)))),
                SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () {
                      if (Get.isDialogOpen ?? false) Get.back();
                    },
                    child: Text('Setuju'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  static showConfirm(
      {required String title,
      required String description,
      String? titlePrimary,
      String? titleSecondary,
      String? dialogType,
      VoidCallback? action}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: Get.textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              dialogType == "DialogType.alert"
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: action,
                            child: Text(
                              titlePrimary ?? 'Ya',
                              style: TextStyle(
                                  color: Colors.red.shade400, fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF5BBFFA),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              if (Get.isDialogOpen ?? false) Get.back();
                            },
                            child: Text(
                              titleSecondary ?? 'Tidak',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              if (Get.isDialogOpen ?? false) Get.back();
                            },
                            child: Text(
                              titleSecondary ?? 'Tidak',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColors.primaryColor,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: action,
                            child: Text(
                              titlePrimary ?? 'Ya',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
