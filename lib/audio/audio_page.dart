import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3/audio/playnow.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  @override

  final _audioQ = new OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();



  playingS(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("Error song");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.storage.request();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music collection"),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.orange,

      ),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQ.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text("Songs no found"),
              );
            };
            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 2,color: Colors.grey)
                ),
                child: ListTile(
                  title: Text(item.data![index].displayNameWOExt),
                  subtitle: Text("${item.data![index].artist}"),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.music_note),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlayNow(songModel: item.data![index], audioPlayer: _audioPlayer,)));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
