final furnitureDetailList = [
  ItemModel(
    imageUrl: 'assets/images/basic.furniture/furniture_detail_01.jpeg',
    title: 'Hemes Armchair',
    subTitle: 'NEW SALE',
    price: '128',
  ),
  ItemModel(
    imageUrl: 'assets/images/basic.furniture/furniture_detail_02.jpeg',
    title: 'Sofar Armchair',
    subTitle: 'OLD SALE',
    price: '328',
  ),
  ItemModel(
    imageUrl: 'assets/images/basic.furniture/furniture_detail_03.jpeg',
    title: 'Wodden Armchair',
    subTitle: 'FRESH SALE',
    price: '628',
  ),
];

class ItemModel {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String price;

  ItemModel({this.imageUrl, this.title, this.subTitle, this.price});
}
