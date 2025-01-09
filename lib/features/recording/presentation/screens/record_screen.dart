import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/recordings_notifier.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
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
          // Center(
          //   child: CupertinoButton(
          //     color: Colors.blue,
          //     onPressed: () =>
          //         ref.read(recordingsNotifierProvider.notifier).getRecordings(),
          //     child: const Text(
          //       'Get Recordings',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recording ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a')
                            .format(recordings[index].createdAt!),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref
                        .read(recordingsNotifierProvider.notifier)
                        .playRecording(recordings[index]),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[800],
                thickness: 0.5,
              );
            },
            itemCount: recordings.length,
          ),
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Column(
              children: [
                ref.watch(recordingsNotifierProvider.notifier).isRecording
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'Recording...',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink(),
                GestureDetector(
                  onTap: () =>
                      ref.read(recordingsNotifierProvider.notifier).record(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      ref.watch(recordingsNotifierProvider.notifier).isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.bottom,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
