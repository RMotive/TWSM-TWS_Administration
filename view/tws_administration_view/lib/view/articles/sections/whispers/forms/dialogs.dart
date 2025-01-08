part of '../sections_create_whisper.dart';

Future<void> _exceptionDialog(BuildContext ctx, String title){
  return showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return TWSConfirmationDialog(
        showCancelButton: false,
        accept: 'OK',
        title: 'fatal error on create $title',
        statement: const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: 'Unexpected problem. Please retry the operation or contact your administrator.'
          ),
        ),
        onAccept: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

Future<void> _failureDialog(BuildContext ctx, String error, String title, List<Object> failures){
  return showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return TWSConfirmationDialog(
        showCancelButton: false,
        accept: 'OK',
        title: 'Error on create $title',
        statement: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: "$error \n\n",
            children: <InlineSpan>[
              if(failures.isNotEmpty)
              const TextSpan(
                text: "The following records cannot be created, please verify the data and retry the operation with this specific records: \n\n",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              if(failures.isNotEmpty)
              for (int i = 0; i < failures.length; i++)
                TextSpan(
                  text: "${i + 1} - Location with name:  ${(failures[i] as SetOperationFailure<Location>).set.name}\n",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
            ],
          )
        ),
        onAccept: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

Future<void> _conectionDialog(BuildContext ctx, String title) {
  return showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return TWSConfirmationDialog(
        showCancelButton: false,
        accept: 'Ok',
        title: 'Conection problems on create $title',
        statement: const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: 'Cannot conect to the server\n Please verify your internet contection or contact your administrator.',
          ),
        ),
        onAccept: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}
