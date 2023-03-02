import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ParticipantsPhotoWidget extends StatelessWidget {
  const ParticipantsPhotoWidget({super.key, required this.photoUrls});
  final List<String> photoUrls;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: CachedNetworkImageProvider(photoUrls.first),
            ),
          ),
          if (photoUrls.length > 1)
            Positioned(
              left: 25,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider(photoUrls[1]),
                ),
              ),
            ),
          if (photoUrls.length == 3)
            Positioned(
              left: 50,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider(photoUrls[2]),
                ),
              ),
            ),
          if (photoUrls.length > 3)
            Positioned(
              left: 50,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text('+${(photoUrls.length - 2)}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
