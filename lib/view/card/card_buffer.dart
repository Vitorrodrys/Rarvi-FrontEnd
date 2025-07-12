import 'package:rarvi/services/api/rarvi_api.dart';
import 'package:rarvi/services/api/schemas/card.dart' as card_schema;


class CardBuffer {

  final RarviAPI _api;
  final int _disciplineId;
  final int _maxBufSize;
  int _index_at = 0;
  List<card_schema.Card> _buffer = [];

  Future<void> _loadCards() async {
    _buffer = await _api.discipline.getRandomByDiscipline(_disciplineId, _maxBufSize);
  }
  CardBuffer(this._api, this._disciplineId, this._maxBufSize);

  Future<card_schema.Card> getNext() async {
    if (_index_at >= _buffer.length || _buffer.isEmpty ) {
      await _loadCards();
      _index_at = 0;
    }
    var card = _buffer[_index_at];
    _index_at++;
    return card;

  }


}