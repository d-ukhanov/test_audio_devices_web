part of 'test_audio_bloc.dart';

@immutable
abstract class TestAudioEvent {}

class RecordEvent extends TestAudioEvent {}

class ChangeInputDeviceEvent extends TestAudioEvent {
  final AudioDevice device;

  ChangeInputDeviceEvent(this.device);
}

class ChangeOutputDeviceEvent extends TestAudioEvent {
  final AudioDevice device;

  ChangeOutputDeviceEvent(this.device);
}

class UpdateDevicesListEvent extends TestAudioEvent {
  final bool updateInputDevices;
  final bool updateOutputDevices;

  UpdateDevicesListEvent({
    this.updateInputDevices = false,
    this.updateOutputDevices = false,
  });
}
