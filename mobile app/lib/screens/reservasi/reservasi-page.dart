import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';

class ReservasiPage extends StatefulWidget {
  const ReservasiPage({Key? key}) : super(key: key);

  @override
  _ReservasiPageState createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {
  ReservasiController reservasiController = Get.put(ReservasiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        title: const Text("Reservasi"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Obx(() => reservasiController.isLoading.value
              ? const Text("loading")
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: reservasiController.reservasi?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reservasiController.reservasi![index].timeSlotId
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              reservasiController
                                  .reservasi![index].namaPerawatan
                                  .toString(),
                            ),
                            Text(
                              reservasiController.reservasi![index].total
                                  .toString(),
                            ),
                            Text(
                              reservasiController
                                  .reservasi![index].statusReservasi
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

  // final _connect = GetConnect();
}
