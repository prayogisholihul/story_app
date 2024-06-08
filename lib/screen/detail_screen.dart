import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/main_provider.dart';

import '../widget/app_bar.dart';

class DetailScreen extends StatefulWidget {
  final String detailId;
  final void Function() onBackPressed;
  final void Function() toMap;

  const DetailScreen(
      {super.key,
      required this.detailId,
      required this.onBackPressed,
      required this.toMap});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? lastDetailId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final detail = Provider.of<MainProvider>(context, listen: false);
        detail.detailStoryEvent(widget.detailId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider provider = context.watch();
    final LocationProvider location = context.watch();

    if (provider.detailStoryState.state == ResultState.Success &&
        provider.detailStoryState.data != null) {
      final data = provider.detailStoryState.data!;
      final lat = data.lat;
      final lon = data.lon;

      if (lat != null && lon != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          location.selectPosition(LatLng(lat, lon));
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        location.resetPosition();
      });
    }

    return Scaffold(
      appBar: const AppBarView(title: 'Detail Story'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: provider.detailStoryState.data?.photoUrl ?? '',
                  errorWidget: (context, url, error) =>
                      const Center(child: CircularProgressIndicator()),
                  fit: BoxFit.cover,
                ),
                if (location.address != null)
                  Positioned(
                      bottom: 20,
                      left: 20,
                      child: InkWell(
                        onTap: widget.toMap,
                        child: Image.asset(
                          'assets/images/map.png',
                          width: 40,
                          height: 40,
                        ),
                      ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 8.0),
              child: Row(
                children: [Text(location.address ?? '')],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                children: [
                  Text(provider.detailStoryState.data?.name ?? ''),
                  const Spacer(),
                  Text(provider.detailStoryState.data?.formattedDate() ?? ''),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                provider.detailStoryState.data?.description ?? '',
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      )),
    );
  }
}
