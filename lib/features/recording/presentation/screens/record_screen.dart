import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/recordings_notifier.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CupertinoButton(
              color: Colors.blue,
              onPressed: () =>
                  ref.read(recordingsNotifierProvider.notifier).record(),
              child: Text(
                  ref.watch(recordingsNotifierProvider.notifier).isRecording
                      ? 'Stop'
                      : 'Record'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: CupertinoButton(
              color: Colors.blue,
              onPressed: () async {
                ref.read(recordingsNotifierProvider.notifier).playRecording(ref
                    .watch(recordingsNotifierProvider.notifier)
                    .currentRecording!
                    .path);
              },
              child: const Text('Play'),
            ),
          ),
        ],
      ),
    );
  }
}
