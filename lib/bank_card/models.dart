import 'dart:math';

const double CARD_ASPECT_RATIO = 1.586; // default aspect ratio for cards

final cards = <BankCard>[
  BankCard(owner: 'Austin Hammond', imgPath: 'assets/images/bank_card/8mbwlbjkbuu01.jpg'),
  BankCard(owner: 'Orla Finch', imgPath: 'assets/images/bank_card/9od0mSo.jpg'),
  BankCard(owner: 'Karen Castillo', imgPath: 'assets/images/bank_card/OO1122575.jpg'),
  BankCard(owner: 'Jamie Franco', imgPath: 'assets/images/bank_card/Vdtct7v.jpg'),
  BankCard(owner: 'Max Norton', imgPath: 'assets/images/bank_card/8mbwlbjkbuu01.jpg'),
  BankCard(owner: 'Martha Craig', imgPath: 'assets/images/bank_card/dark_grunge_bk.jpg'),
  BankCard(owner: 'Maisy Humphrey', imgPath: 'assets/images/bank_card/wood_bk.jpg'),
];

class BankCard {
  BankCard({this.owner, this.imgPath})
      : code = getCode(),
        number = getCreditCardNumber(),
        expirationDate = getExpirationDate();
  final String code;
  final String owner;
  final String imgPath;
  final String number;
  final String expirationDate;
}

const ALL_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

Random random = Random();

String getCreditCardNumber() {
  return '${random.nextInt(9999)}-${random.nextInt(9999)}-${random.nextInt(9999)}-${random.nextInt(9999)}';
}

String getExpirationDate() {
  return '${random.nextInt(12)}/${random.nextInt(20) + 19}';
}

String getCode() {
  return List<String>.generate(4, (_) => ALL_CHARS[random.nextInt(ALL_CHARS.length)]).join();
}
