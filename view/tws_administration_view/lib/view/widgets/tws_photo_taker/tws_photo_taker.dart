import 'dart:convert';
import 'dart:typed_data';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:csm_view/csm_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_file_picker.dart';
part 'tws_photo_taker_photo_preview.dart';
part 'tws_photo_taker_camera.dart';

///
final CameraPlatform _cameraPlatform = CameraPlatform.instance;

///
const CSMAdvisor _advisor = CSMAdvisor('TWSPhotoTaker');

///
final class TWSPhotoTaker extends StatefulWidget {
  /// Preload 
  final XFile? preLoad;

  ///
  final void Function(XFile photo)? onPhotoTaken;
  
  ///
  final bool disabled;

  ///
  final String label;

  ///
  final bool showFilePicker;

  /// When is not empty, shows a preview image from the given base64 string,
  /// similar to [preLoad] property, but showing an image without an initial Xfile object.
  final String? basePreview;

  /// Method to trigger when the cancel button is clicked or the file selection dialog is closed and it's empty.
  final void Function()? onCancel; 

  //
  final bool cancelButtonEnable;

  ///
  const TWSPhotoTaker({
    super.key,
    this.preLoad,
    this.onPhotoTaken,
    this.basePreview,
    this.disabled = false,
    this.label = 'Tomar foto',
    this.showFilePicker = true,
    this.cancelButtonEnable = true,
    this.onCancel,
  });

  @override
  State<TWSPhotoTaker> createState() => _TWSPhotoTakerState();
}

class _TWSPhotoTakerState extends State<TWSPhotoTaker> {
  bool _loadingCamera = true;

  XFile? _photo;
  CameraDescription? _cameraDefinition;
  List<CameraDescription> _cameras = <CameraDescription>[];
  Uint8List? originalImg;

  @override
  void didUpdateWidget(covariant TWSPhotoTaker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preLoad == null) {
      _photo = null;
    }
  }

  void getCameras() {
    if (_cameras.isNotEmpty) {
      setState(() {
        _cameras = <CameraDescription>[];
      });
    }

    _cameraPlatform.availableCameras().then(
      (List<CameraDescription> camerasFound) {
        _cameras = camerasFound;
        CameraDescription cameraDescription = camerasFound.firstWhere(
          (CameraDescription i) => i.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras[0],
        );

        setState(() {
          _cameraDefinition = cameraDescription;
          _loadingCamera = false;
        });
      },
      onError: (Object ex, StackTrace t) {
        _advisor.exception('Camera Exception', Exception(ex), t);
        setState(() {
          _cameras = <CameraDescription>[];
          _loadingCamera = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.basePreview != null) originalImg = base64.decode(widget.basePreview!);
    getCameras();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openCameraDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _TWSPhotoTakerPhotoCamera(
          camera: _cameraDefinition,
          onSave: (XFile file) {
            setState(() {
              _photo = file;
            });
            widget.onPhotoTaken?.call(file);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return CSMSpacingColumn(
      spacing: 8,
      children: <Widget>[
        if (widget.showFilePicker)
          TwsFilePicker(
            dialogTitle: "Select a picture",
            fileType: FileType.image,
            cancelEnable: (_photo != null || widget.basePreview != null) && widget.cancelButtonEnable,
            onSelect: (List<XFile> xFiles, List<PlatformFile> files) {
              setState(() {
                _photo = xFiles.first;
                widget.onPhotoTaken?.call(xFiles.first);
              });
            },
            onCancel: () {
              setState(() {
                _photo = null;
                widget.onCancel?.call();            
              });
            },
          ),
        TWSButtonFlat(
          disabled: _loadingCamera || _cameras.isEmpty || widget.disabled,
          label: _loadingCamera
              ? 'Obteniendo información de las cámaras'
              : _cameras.isNotEmpty
                  ? widget.label
                  : 'No hay cámaras disponibles',
          onTap: _openCameraDialog,
        ),
        CSMSpacingRow(
          spacing: 12,
          children: <Widget>[
            Visibility(
              visible: widget.basePreview == null && _photo == null,
              replacement: CSMPointerHandler(
                cursor: SystemMouseCursors.click,
                onClick: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _TWSPhotoTakerPhotoPreview(
                      file: _photo,
                      originalBytes: originalImg,
                    ),
                  );
                },
                child: _photo == null && originalImg != null
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.memory(
                        originalImg!
                      ),
                    )
                  : Image.network(
                  _photo?.path ?? '',
                  width: 48,
                  height: 48,
                ),
              ),
              child: Icon(
                Icons.photo,
                size: 48,
                color: getTheme<TWSAThemeBase>().page.fore,
              ),
            ),
            Text(
              style: TextStyle(
                color: getTheme<TWSAThemeBase>().page.fore,
              ),
              _photo == null && widget.basePreview == null
                  ? 'Vacío'
                  : 'Foto guardada',
            ),
          ],
        ),
      ],
    );
  }
}
