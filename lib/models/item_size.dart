class ItemSize{

  ItemSize.fromMap(Map<String, dynamic> map){ //passa u item dinamico que acessa o firebase
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
  }

  String name;
  num price;
  int stock;

  bool get hasStock => stock > 0;

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }


}