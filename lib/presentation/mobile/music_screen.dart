import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/mobile/widgets/search_view.dart';

class MusicScreen extends ConsumerStatefulWidget {
  const MusicScreen({super.key});

  @override
  ConsumerState createState() => _MusicScreenState();
}

class _MusicScreenState extends ConsumerState<MusicScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Music'),
            bottom: TabBar(
              tabs: [
                Tab(text: '推荐'),
                Tab(text: '排行榜'),
              ],
            ),
            actions: [
              Expanded(
                  child:Container(
                    margin: const EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
                    child: SearchView(),
                  )
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                color: Colors.red,
                child: const Center(child: Text('Tab 1')),
              ),
              Container(
                color: Colors.green,
                child: const Center(child: Text('Tab 2')),
              ),
            ],
          ),
        ));
  }
}
