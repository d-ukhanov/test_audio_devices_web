library test_audio_devices_web;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/test_audio_bloc.dart';
import 'widgets/ripple_animation_widget.dart';

class TestAudioDevices extends StatelessWidget {
  ///Texts
  final String title;
  final String selectOutputMsg;
  final String selectInputMsg;
  final String defaultSpeakerMsg;
  final String noOutputsMsg;
  final String noInputsMsg;
  final String startCheckMsg;
  final String finishCheckMsg;
  final String refreshIconText;

  ///Colors
  final Color errorTextColor;
  final Color recordTooltipColor;
  final Color activeRecordIconColor;
  final Color disabledRecordIconColor;
  final Color refreshIconColor;
  final Color recordButtonFillColor;
  final Color? activeRecordContainerColor;
  final Color? disabledRecordContainerColor;
  final Color? rippleAnimationColor;

  const TestAudioDevices({
    super.key,
    this.title = 'Check audio devices',
    this.selectOutputMsg = 'Select output device:',
    this.selectInputMsg = 'Select input device:',
    this.defaultSpeakerMsg = 'Speakers are enabled by default',
    this.noOutputsMsg =
        'Your browser is not compatible with all the features of this tool, or your system does not have output devices',
    this.noInputsMsg = 'No input devices found',
    this.startCheckMsg = 'Start check',
    this.finishCheckMsg = 'Finish check',
    this.refreshIconText = 'Refresh',
    this.errorTextColor = Colors.red,
    this.recordTooltipColor = Colors.white,
    this.activeRecordIconColor = Colors.redAccent,
    this.disabledRecordIconColor = Colors.blue,
    this.recordButtonFillColor = Colors.white,
    this.refreshIconColor = Colors.blue,
    this.activeRecordContainerColor,
    this.disabledRecordContainerColor,
    this.rippleAnimationColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestAudioBloc()
        ..add(
          UpdateDevicesListEvent(
            updateInputDevices: true,
            updateOutputDevices: true,
          ),
        ),
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 24.0),
                buildOutputDevicesInfo(context),
                const SizedBox(height: 16.0),
                buildInputDevicesInfo(context),
                const SizedBox(height: 8.0),
                buildRecordButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOutputDevicesInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectOutputMsg,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          BlocBuilder<TestAudioBloc, TestAudioState>(
            buildWhen: (previous, current) {
              return previous.selectedOutputDevice !=
                      current.selectedOutputDevice ||
                  previous.outputDevices != current.outputDevices;
            },
            builder: (context, state) {
              if (state.outputDevices?.isEmpty ?? true) {
                return Column(
                  children: [
                    Text(
                      defaultSpeakerMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: errorTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      noOutputsMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: errorTextColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        DropdownButton<AudioDevice>(
                          value: state.selectedOutputDevice ??
                              state.outputDevices!.first,
                          underline: const SizedBox(),
                          isExpanded: true,
                          onChanged: (AudioDevice? device) {
                            if (device != null) {
                              context
                                  .read<TestAudioBloc>()
                                  .add(ChangeOutputDeviceEvent(device));
                            }
                          },
                          items: state.outputDevices!
                              .map<DropdownMenuItem<AudioDevice>>(
                                  (AudioDevice device) {
                            return DropdownMenuItem<AudioDevice>(
                              value: device,
                              child: Text(
                                device.label,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                        ),
                        const Divider(height: 0.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  getRefreshIcon(
                    context,
                    onPressed: () => context
                        .read<TestAudioBloc>()
                        .add(UpdateDevicesListEvent(updateOutputDevices: true)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildInputDevicesInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectInputMsg,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          BlocBuilder<TestAudioBloc, TestAudioState>(
            buildWhen: (previous, current) {
              return previous.selectedInputDevice !=
                      current.selectedInputDevice ||
                  previous.inputDevices != current.inputDevices;
            },
            builder: (context, state) {
              if (state.inputDevices?.isEmpty ?? true) {
                return Text(
                  noInputsMsg,
                  style: TextStyle(
                    color: errorTextColor,
                    fontSize: 16.0,
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        DropdownButton<AudioDevice>(
                          value: state.selectedInputDevice ??
                              state.inputDevices!.first,
                          underline: const SizedBox(),
                          isExpanded: true,
                          onChanged: (AudioDevice? device) {
                            if (device != null) {
                              context
                                  .read<TestAudioBloc>()
                                  .add(ChangeInputDeviceEvent(device));
                            }
                          },
                          items: state.inputDevices!
                              .map<DropdownMenuItem<AudioDevice>>(
                                  (AudioDevice device) {
                            return DropdownMenuItem<AudioDevice>(
                              value: device,
                              child: Text(
                                device.label,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                        ),
                        const Divider(height: 0.0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  getRefreshIcon(
                    context,
                    onPressed: () => context
                        .read<TestAudioBloc>()
                        .add(UpdateDevicesListEvent(updateInputDevices: true)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildRecordButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: BlocSelector<TestAudioBloc, TestAudioState, RecordStatus>(
          selector: (state) => state.recordStatus,
          builder: (context, recordStatus) {
            return Stack(
              alignment: Alignment.center,
              children: [
                RippleAnimationWidget(
                  display: recordStatus == RecordStatus.recording,
                  color: rippleAnimationColor ?? Colors.red.shade400,
                  size: 250,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getRecordColor(context, recordStatus),
                  ),
                  child: Tooltip(
                    message: getTooltipMessage(context, recordStatus),
                    textStyle: TextStyle(
                      color: recordTooltipColor,
                      fontSize: 14.0,
                    ),
                    child: RawMaterialButton(
                      fillColor: recordButtonFillColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(30),
                      onPressed: () =>
                          context.read<TestAudioBloc>().add(RecordEvent()),
                      child: getRecordIcon(context, recordStatus),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color getRecordColor(BuildContext context, RecordStatus status) {
    if (status == RecordStatus.recording) {
      return activeRecordContainerColor ?? Colors.red.withOpacity(0.5);
    } else {
      return disabledRecordContainerColor ?? Colors.blue.withOpacity(0.7);
    }
  }

  Icon getRecordIcon(BuildContext context, RecordStatus status) {
    switch (status) {
      case RecordStatus.init:
        return Icon(
          Icons.mic,
          color: disabledRecordIconColor,
          size: 50,
        );
      case RecordStatus.recording:
        return Icon(Icons.mic, color: activeRecordIconColor, size: 50);
    }
  }

  String getTooltipMessage(BuildContext context, RecordStatus status) {
    switch (status) {
      case RecordStatus.init:
        return startCheckMsg;
      case RecordStatus.recording:
        return finishCheckMsg;
    }
  }

  Widget getRefreshIcon(BuildContext context,
      {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: IconButton(
          icon: Icon(
            Icons.refresh,
            color: refreshIconColor,
          ),
          iconSize: 30,
          tooltip: refreshIconText,
          splashRadius: 20,
          onPressed: onPressed),
    );
  }
}
