import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../state/recordings_notifier.dart';

class RecordingTile extends ConsumerWidget {
  const RecordingTile({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              DateFormat('h:mm a').format(ref
                  .watch(recordingsNotifierProvider.notifier)
                  .recordings[index]
                  .createdAt!),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            ref
                .read(recordingsNotifierProvider.notifier)
                .setCurrentPlayingRecordingIndex(index);
            ref.read(recordingsNotifierProvider.notifier).playRecording(ref
                .watch(recordingsNotifierProvider.notifier)
                .recordings[index]);
          },
          child: !(ref.watch(currentPlayingRecordingIndexProvider) == index)
              ? const Icon(
                  Icons.play_arrow_rounded,
                  size: 24,
                  color: Colors.white,
                )
              : StreamBuilder<PlayerState>(
                  stream: ref
                      .read(recordingsNotifierProvider.notifier)
                      .audioPlayer
                      .playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;

                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return const CupertinoActivityIndicator(
                        color: Colors.white,
                      );
                    } else if (playing != true) {
                      return GestureDetector(
                        onTap: ref
                            .read(recordingsNotifierProvider.notifier)
                            .audioPlayer
                            .play,
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return GestureDetector(
                        onTap: ref
                            .read(recordingsNotifierProvider.notifier)
                            .audioPlayer
                            .pause,
                        child: const Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => ref
                            .read(recordingsNotifierProvider.notifier)
                            .audioPlayer
                            .seek(Duration.zero),
                        child: const Icon(
                          Icons.replay,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}
