import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          'https://img.freepik.com/free-photo/woman-washing-head-hairsalon_1157-27179.jpg?w=826&t=st=' +
              '1684567967~exp=1684568567~hmac=fc0161204a5b3704d459e18390325ebea95d8484593655f4539f50ff8d3537a2',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
