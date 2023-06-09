import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/notifikasi.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({Key? key}) : super(key: key);

  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  NotifikasiController notifikasiController = Get.put(NotifikasiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        title: const Text("Notifikasi"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Obx(() => notifikasiController.isLoading.value
              ? const Text("loading")
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: notifikasiController.notifikasi?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifikasiController.notifikasi![index].title
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              notifikasiController.notifikasi![index].body
                                  .toString(),
                            ),
                            const Divider(
                              height: 5,
                            )
                          ],
                        ),
                      ],
                    );
                  }))
        ]),
      ),
    );
  }
}
