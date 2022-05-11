import 'dart:io';

import 'package:evcards/src/views/cards/view_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: Colors.grey,
      body: Stack(alignment: Alignment.center, children: [
        // Container(
        //   decoration: BoxDecoration(
        //     boxShadow: [
        //       BoxShadow(color: Colors.blueGrey.withOpacity(0.1), blurRadius: 2)
        //     ],
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/colorbg.jpg'),
        //     ),
        //     border: Border.all(color: Colors.grey, width: 3),
        //     // borderRadius: BorderRadius.circular(60)
        //   ),
        // ),
        buildQRView(context),
        Positioned(bottom: 40, child: buildResult())
      ]),
    ));
  }

  Widget buildResult() => GestureDetector(
        onTap: () {
          if (result != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewCard(
                        uid: result!.code,
                      )),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(8)),
          child: Text(
            result != null ? "Result:${result!.code}" : "Scan a Code!",
            style: TextStyle(color: Colors.white),
            maxLines: 3,
          ),
        ),
      );
  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).canvasColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
