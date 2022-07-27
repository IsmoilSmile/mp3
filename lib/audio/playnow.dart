import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayNow extends StatefulWidget {
  PlayNow({Key? key, required this.songModel, required this.audioPlayer})
      : super(key: key);
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayNow> createState() => _PlayNowState();
}

class _PlayNowState extends State<PlayNow> {

  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlay = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playsong();
    widget.audioPlayer;
  }

  void playsong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();
      _isPlay = true;
    } on Exception {
      log("Not Parse");
    }
    widget.audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration!;
      });
    });
    widget.audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Music"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 70,
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                     backgroundColor: Colors.orange,
                      radius: 130,
                      child: Icon(
                        Icons.music_note,
                        size: 70,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.songModel.artist.toString() == "<unknown>"
                          ? "Unknown"
                          : widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(_position.toString().split(".")[0]),
                        Expanded(
                          child: Slider(
                              min: Duration(microseconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  changeSong(value.toInt());
                                  value = value;
                                });
                              }),
                        ),
                        Text(_duration.toString().split(".")[0]),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            if(widget.audioPlayer.hasPrevious){
                              widget.audioPlayer.seekToPrevious();
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_isPlay) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                              _isPlay = !_isPlay;
                            });
                          },
                          icon: Icon(
                            _isPlay ? Icons.pause : Icons.play_arrow,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if(widget.audioPlayer.hasNext){
                              widget.audioPlayer.seekToNext();
                            }
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeSong(int second) {
    Duration duration = Duration(seconds: second);
    widget.audioPlayer.seek(duration);
  }
}
