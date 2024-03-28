import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/main_provider.dart';
import 'package:story_app/widget/image_loading.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final void Function() onTap;

  const HomeScreen({super.key, required this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MainProvider>(context, listen: false).getStories();
  }

  String formatDate(DateTime time) {
    final df = DateFormat.yMd();
    return df.format(time);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    // print(formatDate(provider.stories.data![0].createdAt));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onTap,
        child: const Icon(Icons.logout),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: provider.stories.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            provider.stories.data?[index].name ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            provider.stories.data?[index].description ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ImageWithLoading(
                            imageUrl:
                                provider.stories.data?[index].photoUrl ?? ''),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            provider.stories.data?[index].createdAt != null
                                ? formatDate(provider.stories.data![index].createdAt)
                                : '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
