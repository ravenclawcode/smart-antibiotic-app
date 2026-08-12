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
              progressIndicatorColor: AppColors.error,
            ),
          ),
          // Positioned(
          //   top: 16,
          //   child: SafeArea(
          //     child: InkWell(
          //       focusColor: Colors.transparent,
          //       hoverColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       splashColor: Colors.transparent,
          //       onTap: () => Navigator.pop(context),
          //       child: Container(
          //         width: 36,
          //         height: 36,
          //         decoration: BoxDecoration(
          //           color: AppColors.textPrimary.withValues(alpha: 0.65),
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Icon(
          //           Icons.arrow_back_ios_new_rounded,
          //           size: 20,
          //           color: AppColors.surfacePrimary,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
