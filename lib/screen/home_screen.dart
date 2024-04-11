import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
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
    final provider = context.watch<MainProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: const AppBarView(title: 'Story App'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: widget.toGallery,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: provider.stories.state == ResultState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : listContent(provider.stories.data ?? []),
            ),
          ],
        ),
      ),
    );
  }

  Widget listContent(List<StoryData> data) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 50),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 14, right: 14),
            child: InkWell(
                onTap: () {
                  widget.toDetail(data[index].id);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        data[index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    ImageWithLoading(imageUrl: data[index].photoUrl),
                  ],
                )),
          );
        });
  }
}
