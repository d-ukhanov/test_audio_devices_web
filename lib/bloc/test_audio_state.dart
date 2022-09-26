part of 'test_audio_bloc.dart';

enum RecordStatus { init, recording}

@immutable
class AudioDevice {
  final String deviceId;
  final String label;
  final String? kind;

  const AudioDevice({
    required this.deviceId,
    required this.label,
    required this.kind,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioDevice &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId &&
          label == other.label &&
          kind == other.kind;

  @override
  int get hashCode => deviceId.hashCode ^ label.hashCode ^ kind.hashCode;
}

@immutable
class TestAudioState {
  final RecordStatus recordStatus;
  final List<AudioDevice>? inputDevices;
  final List<AudioDevice>? outputDevices;
  final AudioDevice? selectedInputDevice;
  final AudioDevice? selectedOutputDevice;

  const TestAudioState({
    this.recordStatus = RecordStatus.init,
    this.inputDevices,
    this.outputDevices,
    this.selectedInputDevice,
    this.selectedOutputDevice,
  });

  TestAudioState copyWith({
    RecordStatus? recordStatus,
    List<AudioDevice>? inputDevices,
    List<AudioDevice>? outputDevices,
    AudioDevice? selectedInputDevice,
    AudioDevice? selectedOutputDevice,
  }) {
    return TestAudioState(
      recordStatus: recordStatus ?? this.recordStatus,
      inputDevices: inputDevices ?? this.inputDevices,
      outputDevices: outputDevices ?? this.outputDevices,
      selectedInputDevice: selectedInputDevice ?? this.selectedInputDevice,
      selectedOutputDevice: selectedOutputDevice ?? this.selectedOutputDevice,
    );
  }
}
