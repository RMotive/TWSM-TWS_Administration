import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:csm_view/csm_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';

/// [TwsFilePicker] Widget that shows a dialog (web or mobile) to select one or multiple specified extension files.
class TwsFilePicker extends StatefulWidget {
  /// Title for the file picker dialog.
  final String dialogTitle;
  /// Specify the selectable file type. 
  final FileType fileType;
  /// Specify the file extension allowed.
  final List<String>? allowedExtensions;
  /// Function to trigger on finishing file loading.
  final dynamic Function(FilePickerStatus)? onFileLoading;
  /// Function to trigger when the dialog is closed without any selection.
  final void Function()? onCancel;
  /// Return the user file selection in both, [XFile] and [PlatformFile] format.
  final void Function(List<XFile> xFiles, List<PlatformFile> files) onSelect;
  /// The cancel button always is enable. This is useful for some cases in other widgets implementations.
  final bool cancelEnable;
  
  const TwsFilePicker({
    super.key,
    required this.dialogTitle,
    required this.onSelect,
    this.fileType  = FileType.any,
    this.cancelEnable = false,
    this.allowedExtensions,
    this.onFileLoading,
    this.onCancel,
  });

  @override
  State<TwsFilePicker> createState() => _TwsFilePickerState();
}

class _TwsFilePickerState extends State<TwsFilePicker> {
  // Lists to store the user selection.
  late List<XFile> selectedXfiles;
  late List<PlatformFile> selectedPlatformFiles;

  void clearStorage(){
    widget.onCancel?.call();
    setState(() {
      selectedPlatformFiles = <PlatformFile>[];
      selectedXfiles = <XFile>[];
    });
  }

  @override
  void initState() {
    selectedXfiles = <XFile>[];
    selectedPlatformFiles = <PlatformFile>[];
    super.initState();
  }

  void pickFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      dialogTitle: widget.dialogTitle,
      type: widget.fileType,
      allowedExtensions:  widget.allowedExtensions,
      onFileLoading: widget.onFileLoading,
    );
    // On select files
    if (filePickerResult != null) {
      setState(() {
        selectedXfiles = filePickerResult.xFiles;
        selectedPlatformFiles = filePickerResult.files;
        widget.onSelect(selectedXfiles, selectedPlatformFiles);
      });

    } else {
      // When the user cancel the selection:
      setState(() {
        widget.onCancel;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return CSMSpacingRow(
      spacing: 10,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: TWSButtonFlat(
            label: selectedXfiles.isNotEmpty? selectedXfiles.first.name : selectedPlatformFiles.isNotEmpty ? selectedPlatformFiles.first.name : "Select files",
            onTap: () => pickFile(),
          ),
        ),
        Expanded(
          child: TWSButtonFlat(
            label: "Cancel",
            onTap: () => clearStorage(),
            disabled: (selectedXfiles.isEmpty || selectedPlatformFiles.isEmpty) && !widget.cancelEnable,
          ),
        ),
      ],
    );
  }
}
