part of 'tws_photo_taker.dart';

final class _TWSPhotoTakerPhotoPreview extends StatelessWidget {
  final XFile? file;

  final Uint8List? originalBytes;

  const _TWSPhotoTakerPhotoPreview({
    this.file,
    this.originalBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1280,
          maxHeight: 720,
        ),
        child: Stack(
          children: <Widget>[
            ///
            if(file != null)
            Image.network(
              file!.path,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),

            if(originalBytes != null && file == null)
            Image.memory(
              originalBytes!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
             
            ///
            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints cts) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: TWSButtonFlat(
                      label: 'Close',
                      width: cts.maxWidth * .1,
                      onTap: () {
                        CSMRouter.i.pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
