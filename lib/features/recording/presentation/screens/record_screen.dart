import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/recordings_notifier.dart';
import '../widgets/recording_bar.dart';
import '../widgets/recording_tile.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recordingsNotifierProvider.notifier).getRecordings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingsNotifierProvider);
    final recordings =
        ref.watch(recordingsNotifierProvider.notifier).recordings;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'All Recordings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          recordingState.maybeWhen(loading: () {
            return const Expanded(
              child: Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }, orElse: () {
            return recordings.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        'Tap the mic to start recording',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemBuilder: (context, index) {
                        return RecordingTile(index: index);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey[800],
                          thickness: 0.5,
                        );
                      },
                      itemCount: recordings.length,
                    ),
                  );
          }),
          const RecordingBar(),
        ],
      ),
    );
  }
}
