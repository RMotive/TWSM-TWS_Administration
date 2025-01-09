import 'package:tws_foundation_client/tws_foundation_client.dart';

abstract interface class TWSAutocompleteAdapter{
  Future<List<SetViewOut<dynamic>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input);
}