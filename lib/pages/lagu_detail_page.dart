import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/core.dart';

import 'package:flutter_lagu_daerah_app/data/models/lagu_response_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LaguDetailPage extends StatefulWidget {
  final Lagu lagu;
  const LaguDetailPage({
    super.key,
    required this.lagu,
  });

  @override
  State<LaguDetailPage> createState() => _LaguDetailPageState();
}

class _LaguDetailPageState extends State<LaguDetailPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController laguController = TextEditingController();
  final TextEditingController daerahController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  XFile? image;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    judulController.text = widget.lagu.judul;
    laguController.text = widget.lagu.lagu;
    daerahController.text = widget.lagu.daerah;
    videoUrlController.text = widget.lagu.videoUrl;

    // Initialize YouTube player controller
    if (widget.lagu.videoUrl.isNotEmpty) {
      String? videoId = YoutubePlayer.convertUrlToId(widget.lagu.videoUrl);
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true, // Set autoPlay to true
          mute: false,
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lagu.judul),
        elevation: 2,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.lagu.judul,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.lagu.daerah,
            textAlign: TextAlign.center,
          ),
          widget.lagu.imageUrl == null
              ? const SizedBox()
              : Transform.translate(
                  offset: const Offset(0, -30), // Menggeser gambar ke atas
                  child: Image.network(
                    '${LaguRemoteDataSource.imageUrl}/${widget.lagu.imageUrl}',
                    height: 300,
                  ),
                ),
          widget.lagu.videoUrl.isNotEmpty && _youtubePlayerController != null
              ? Transform.translate(
                  offset: const Offset(0, -60), // Menggeser video ke atas
                  child: YoutubePlayer(
                    controller: _youtubePlayerController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Video URL tidak tersedia atau salah.'),
                ),
          const SizedBox(height: 6), // Mengurangi jarak di bawah video

          Transform.translate(
            offset: const Offset(0, -40), // Menggeser container ke atas
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 230, 230),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                widget.lagu.lagu,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
