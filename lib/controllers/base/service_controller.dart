// ignore_for_file: avoid_print, unused_field

import 'package:passify/helpers/dialog_helper.dart';
import 'package:passify/services/service_exception.dart';
import 'package:get/get.dart';

class ServiceController {
  void handleError(error) {
    if (error is BadRequestException) {
      Get.back();

      var message = error.message;
      var url = error.url;

      if (url == '/provinsi') {
        print(message);
      } else {}
    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      print(message);
    } else if (error is UnauthorizedException) {
      var message = error.message;
      print(message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showError(description: message);
    }
  }

  static final _errorMessages = {
    '/provinsi': {
      'title': 'Gagal',
      'description':
          'Waduh sepertinya ada masalah saat melakukan load Provinsi. Pastikan koneksi anda stabil dan silahkan coba lagi.',
    },
  };
}
