import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/main_provider.dart';

import '../widget/app_bar.dart';

class DetailScreen extends StatefulWidget {
  final String detailId;
  final void Function() onBackPressed;

  const DetailScreen(
      {super.key, required this.detailId, required this.onBackPressed});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    Provider.of<MainProvider>(context, listen: false)
        .detailStoryEvent(widget.detailId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider provider = context.watch();

    return Scaffold(
      appBar: const AppBarView(title: 'Detail Story'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: provider.detailStoryState.data?.photoUrl ?? '',
              errorWidget: (context, url, error) =>
              const Center(child: CircularProgressIndicator()),
              fit: BoxFit.cover,
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
            const SizedBox(height: 12,),
            Text(provider.detailStoryState.data?.description ?? ''),
            const SizedBox(height: 24,)
          ],
        ),
      )),
    );
  }
}
