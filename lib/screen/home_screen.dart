import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/main_provider.dart';
import 'package:story_app/widget/app_bar.dart';
import 'package:story_app/widget/image_loading.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final void Function() toLogout;
  final void Function() toGallery;
  final void Function(String) toDetail;

  const HomeScreen(
      {super.key,
      required this.toLogout,
      required this.toGallery,
      required this.toDetail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<MainProvider>(context, listen: false).getStories();
    Provider.of<AuthProvider>(context, listen: false).getUser();
  }

  String formatDate(DateTime time) {
    final df = DateFormat.yMd();
    return df.format(time);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MainProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: const AppBarView(title: 'Story App'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: widget.toGallery,
        child: const Icon(Icons.add),
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 100,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.user.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    auth.user.email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: widget.toLogout,
            )
          ],
        ),
      ),
      body: PagedListView<int, StoryData>(
        pagingController: provider.pagingController,
        builderDelegate: PagedChildBuilderDelegate<StoryData>(
          itemBuilder: (context, item, index) => listContent(item)
        ),
      ),
    );
  }

  Widget listContent(StoryData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 14, right: 14),
      child: InkWell(
          onTap: () {
            widget.toDetail(data.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  data.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ImageWithLoading(imageUrl: data.photoUrl),
            ],
          )),
    );
  }
}
