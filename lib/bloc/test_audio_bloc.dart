import 'dart:async';
import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'test_audio_event.dart';
part 'test_audio_state.dart';

class TestAudioBloc extends Bloc<TestAudioEvent, TestAudioState> {
  html.AudioElement? _audioContainer;
  bool _isRecording = false;

  TestAudioBloc() : super(const TestAudioState()) {
    html.window.navigator.mediaDevices?.addEventListener(
      'devicechange',
      (event) => add(
        UpdateDevicesListEvent(
          updateInputDevices: true,
          updateOutputDevices: true,
        ),
      ),
    );

    on<RecordEvent>((event, emit) async {
      switch (state.recordStatus) {
        case RecordStatus.init:
          emit(state.copyWith(recordStatus: RecordStatus.recording));

          _isRecording = true;
          await _audioContainer?.play();
          return;
        case RecordStatus.recording:
          emit(state.copyWith(recordStatus: RecordStatus.init));

          _isRecording = false;
          _audioContainer?.pause();
          return;
      }
    });

    on<UpdateDevicesListEvent>((event, emit) async {
      final mediaStreamObj = await _getMediaStream({'audio': true});

      if (mediaStreamObj != null) {
        final devices = await _enumerateDevices();
        List<AudioDevice>? inputDevices;
        List<AudioDevice>? outputDevices;

        if (event.updateInputDevices) {
          inputDevices =
              devices?.where((device) => device.kind == 'audioinput').toList();
        }
        if (event.updateOutputDevices) {
          outputDevices =
              devices?.where((device) => device.kind == 'audiooutput').toList();
        }

        if (_audioContainer == null) {
          _createAudioElement(mediaStreamObj);
        }

        if (inputDevices?.isNotEmpty == true &&
            inputDevices?.first.deviceId != null) {
          add(ChangeInputDeviceEvent(inputDevices!.first));
        }

        if (outputDevices?.isNotEmpty == true &&
            outputDevices?.first.deviceId != null) {
          add(ChangeOutputDeviceEvent(outputDevices!.first));
        }

        emit(
          state.copyWith(
            inputDevices: inputDevices,
            outputDevices: outputDevices,
          ),
        );
      }
    });

    on<ChangeInputDeviceEvent>(
          (event, emit) {
        _changeAudioInput(event.device.deviceId);

        emit(state.copyWith(selectedInputDevice: event.device));
      },
    );

    on<ChangeOutputDeviceEvent>(
      (event, emit) {
        _audioContainer?.setSinkId(event.device.deviceId);

        emit(state.copyWith(selectedOutputDevice: event.device));
      },
    );
  }

  void _createAudioElement(html.MediaStream mediaStreamObj) {
    _audioContainer = html.document.createElement('audio') as html.AudioElement;

    html.document.body!.children.add(_audioContainer!);

    _audioContainer?.srcObject = mediaStreamObj;
  }

  Future<void> _changeAudioInput(String deviceId) async {
    final mediaConstraints = {
      'audio': {'deviceId': deviceId},
    };

    final mediaStreamObj = await _getMediaStream(mediaConstraints);
    _audioContainer?.srcObject = mediaStreamObj;

    if (_isRecording) {
      _audioContainer?.play();
    }
  }

  Future<List<AudioDevice>?> _enumerateDevices() async {
    final devices =
        await html.window.navigator.mediaDevices?.enumerateDevices();

    return devices?.map((e) {
      final input = e as html.MediaDeviceInfo;

      return AudioDevice(
        deviceId:
            input.deviceId ?? 'Generated Device Id :(${devices.indexOf(e)})',
        label: input.label ?? 'Generated label :(${devices.indexOf(e)})',
        kind: input.kind,
      );
    }).toList();
  }

  Future<html.MediaStream?> _getMediaStream(Map constraints) async {
    final mediaDevices = html.window.navigator.mediaDevices;
    if (mediaDevices == null) return null;

    try {
      final mediaStreamObj = await mediaDevices.getUserMedia(constraints);
      return mediaStreamObj;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() async {
    _audioContainer?.remove();

    return super.close();
  }
}
