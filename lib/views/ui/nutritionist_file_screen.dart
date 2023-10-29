import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay/views/shared/app_style.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NutritionistFileScreen extends StatefulWidget {
  final String fileType;
  final String fileUrl;
  final String fileName;
  const NutritionistFileScreen({
    super.key,
    required this.fileType,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  State<NutritionistFileScreen> createState() => NutritionistFileScreenState();
}

class NutritionistFileScreenState extends State<NutritionistFileScreen> {
  PdfViewerController? _pdfViewerController;

  Future download(String url, String filename) async {
    var savePath = '/storage/emulated/0/Download/$filename';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      var file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);

      notifySuccess();

      await raf.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void notifySuccess() {
    final snackBar = SnackBar(
      content: Text(
        '${widget.fileType == 'application/pdf' ? 'PDF' : 'Image'} has been downloaded',
        style: appstyle(12, Colors.white, FontWeight.normal),
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
                decoration: BoxDecoration(border: Border.all(width: 0.2))),
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Container(
            height: 45,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo-name.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await download(
                  widget.fileUrl,
                  widget.fileName,
                );
              },
              icon: const Icon(
                Icons.download,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: widget.fileType == 'application/pdf'
              ? SfPdfViewer.network(
                  controller: _pdfViewerController,
                  widget.fileUrl,
                  enableTextSelection: true,
                )
              : InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.5,
                  maxScale: 2,
                  child: Image.network(
                    widget.fileUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
        ),
      ),
    );
  }
}
