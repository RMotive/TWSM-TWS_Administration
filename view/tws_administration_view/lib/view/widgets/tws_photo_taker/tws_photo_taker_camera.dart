part of 'tws_photo_taker.dart';

///
final class _TWSPhotoTakerPhotoCamera extends StatefulWidget {

  ///
  final void Function(XFile) onSave;

  ///
  final CameraDescription? camera;

  ///
  const _TWSPhotoTakerPhotoCamera({
    required this.camera,
    required this.onSave,
  });

  @override
  State<_TWSPhotoTakerPhotoCamera> createState() => _TWSPhotoTakerPhotoCameraState();
}

class _TWSPhotoTakerPhotoCameraState extends State<_TWSPhotoTakerPhotoCamera> {
  ///
  late TWSAThemeBase _theme;

  ///
  int? _camera;

  ///
  XFile? _photo;

  ///
  bool initingCamera = true;

  ///
  CameraDescription? _cameraDefinition;

  ///
  Widget _composeSafePreview() {
    if (_camera == null) return const SizedBox();

    return _cameraPlatform.buildPreview(_camera!);
  }

  ///
  void _themeEffect() {
    setState(() {
      _theme = getTheme();
    });
  }

  ///
  @override
  void initState() {
    super.initState();

    _theme = getTheme(
      updateEfect: _themeEffect,
    );

    _cameraDefinition = widget.camera;
    if (_cameraDefinition != null) {
      _cameraPlatform.createCamera(_cameraDefinition!, ResolutionPreset.high).then(
        (int cameraId) {
          _cameraPlatform.initializeCamera(cameraId).then(
            (_) {
              setState(() {
                _camera = cameraId;
                initingCamera = false;
              });
            },
          ).onError(
            (Exception ex, StackTrace st) {
              _advisor.exception('Unable to initialize camera', ex, st);
              setState(() {
                _camera = null;
                initingCamera = false;
              });
            },
          );
        },
      ).onError(
        (Exception ex, StackTrace st) {
          _advisor.exception('Unable to create camera', ex, st);
          setState(() {
            _camera = null;
            initingCamera = false;
          });
        },
      );
    }
  }

  ///
  @override
  void dispose() {
    disposeEffect(_themeEffect);
    if (_camera != null) {
      _cameraPlatform.dispose(_camera!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ColoredBox(
        color: getTheme<TWSAThemeBase>().page.main,
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: (_camera == null || initingCamera),
              replacement: Visibility(
                visible: _photo == null,
                replacement: Image.network(
                  _photo?.path ?? '',
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                ),
                child: _composeSafePreview(),
              ),
              child: Center(
                child: Text(initingCamera ? 'Cargando cámara' : 'No hay cámaras disponibles'),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: _theme.primaryCriticalControl.fore,
                    size: 32,
                  ),
                  onPressed: () {
                    CSMRouter.i.pop();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _photo != null,
                      child: CSMSpacingRow(
                        spacing: 8,
                        children: <Widget>[
                          TWSButtonFlat(
                            label: 'Guardar',
                            onTap: () {
                              widget.onSave(_photo!);
                              CSMRouter.i.pop();
                            },
                          ),
                          TWSButtonFlat(
                            label: 'Retomar',
                            onTap: () {
                              setState(() {
                                _photo = null;
                              });
                              
                              _cameraPlatform.resumePreview(_camera!);
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !(widget.camera == null || _photo != null),
                      child: IconButton(
                        enableFeedback: true,
                        color: _theme.page.fore,
                        disabledColor: _theme.primaryDisabledControl.main,
                        icon: const Icon(
                          Icons.camera,
                          size: 48,
                        ),
                        onPressed: () {
                          if(_camera != null){
                            _cameraPlatform.takePicture(_camera!).then(
                              (XFile photo) {
                                setState(() {
                                  _photo = photo;
                                });
                              },
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
