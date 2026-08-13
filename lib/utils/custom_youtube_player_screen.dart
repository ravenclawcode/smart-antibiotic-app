import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubePlayerScreen extends StatefulWidget {
  final String videoUrl;

  const CustomYoutubePlayerScreen({super.key, required this.videoUrl});

  @override
  State<CustomYoutubePlayerScreen> createState() =>
      _CustomYoutubePlayerScreenState();
}

class _CustomYoutubePlayerScreenState extends State<CustomYoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        forceHD: true,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.primary,
              bottomActions: [
                const SizedBox(width: 40),
                CurrentPosition(),
                const SizedBox(width: 8),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: AppColors.primary,
                    handleColor: AppColors.primary,
                  ),
                ),
                RemainingDuration(),
                const PlaybackSpeedButton(),
                IconButton(
                  icon: Icon(
                    Icons.fullscreen_exit_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
