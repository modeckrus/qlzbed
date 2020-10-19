import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

part 'imagecapture_event.dart';
part 'imagecapture_state.dart';

class ImagecaptureBloc extends Bloc<ImagecaptureEvent, ImagecaptureState> {
  ImagecaptureBloc({@required this.storage}) : super(ImagecaptureInitial());
  StreamSubscription<StorageTaskEvent> _streamSubscription;
  StorageUploadTask _task;
  final StorageReference storage;

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ImagecaptureState> mapEventToState(
    ImagecaptureEvent event,
  ) async* {
    if (event is ImageCaptureStartUpload) {
      print('start uploading');
      _task = storage.child(event.path).putFile(event.file);
      _streamSubscription = _task.events.listen((StorageTaskEvent sevent) {
        if (sevent.type == StorageTaskEventType.progress) {
          double progressPercent = event != null
              ? sevent.snapshot.bytesTransferred /
                  sevent?.snapshot?.totalByteCount
              : 0;
          print('progress: ' + progressPercent.toString());
          add(ImageCaptureProgressE(progressPercent));
        }
        if (sevent.type == StorageTaskEventType.pause) {
          print('Pause uploading');
          add(ImageCapturePauseE());
        }
        if (sevent.type == StorageTaskEventType.resume) {
          print('Resume Uploading');

          //add(ImageCapture)
        }
        if (sevent.type == StorageTaskEventType.success) {
          print('succsessfully uploaded');
          add(ImageCaptureSuccessfulE());
        }
      }, onDone: () {
        print('Uploading done');
        add(ImageCaptureFinishE());
      }, onError: (error) {
        print('Error: ' + error.toString());
        add(ImageCaptureErrorE());
      });
    }
    if (event is ImageCaptureCancelUploadE) {
      _streamSubscription?.cancel();
      _task = null;
      yield ImagecaptureInitial();
    }
    if (event is ImageCaptureCompleteUploadE) {
      yield ImageCaptureCompleteUploadS();
    }
    if (event is ImageCaptureFinishE) {
      yield ImageCaptureFinishedS();
    }
    if (event is ImageCapturePauseE) {
      yield ImageCapturePauseS();
    }
    if (event is ImageCaptureProgressE) {
      yield ImageCaptureProgressS(event.persent);
    }
    if (event is ImageCaptureResumeE) {
      _task.resume();
    }
    if (event is ImageCaptureSuccessfulE) {
      _streamSubscription?.cancel();
      _task = null;
      yield ImageCaptureSuccessfulS();
    }
  }
}
