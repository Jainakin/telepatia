import 'package:flutter/material.dart';
import 'package:flutter_animated_progress/flutter_animated_progress.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

import '../state/recordings_notifier.dart';

class RecordingBar extends ConsumerStatefulWidget {
  const RecordingBar({super.key});

  @override
  ConsumerState<RecordingBar> createState() => _RecordingBarState();
}

class _RecordingBarState extends ConsumerState<RecordingBar> {
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(recordingsNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          recordingState.maybeWhen(
            uploading: (progress) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: AnimatedLinearProgressIndicator(
                  value: recordingState.maybeWhen(
                    uploading: (progress) => progress,
                    orElse: () => 0.0,
                  ),
                  animationDuration: const Duration(seconds: 2),
                  minHeight: 7,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  backgroundColor: Colors.grey[800],
                ),
              );
            },
            orElse: () {
              return ref.watch(recordingsNotifierProvider.notifier).isRecording
                  ? SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: AnimatedWaveList(
                          stream: ref
                              .watch(recordingsNotifierProvider.notifier)
                              .audioRecorder
                              .onAmplitudeChanged(
                                  const Duration(milliseconds: 50))
                              .map(
                                (a) =>
                                    Amplitude(current: a.current, max: a.max),
                              )
                              .asBroadcastStream(),
                          //  ref
                          //         .watch(recordingsNotifierProvider.notifier)
                          //         .amplitudeStream ??
                          //     const Stream.empty(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                isRecording = !isRecording;
              });
              // if (isRecording) {
              // FlutterBackgroundService().invoke('record');
              // } else {
              ref.read(recordingsNotifierProvider.notifier).record();
              // FlutterBackgroundService().invoke('upload');
              // }
            },
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
          ),
        ],
      ),
    );
  }
}
