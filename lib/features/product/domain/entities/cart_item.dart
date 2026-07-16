class CartItem {
  final int id;
  final String name;
  final String code;
  final double price;
  final int stock;
  final String image;
  final String description;
  int count;

  CartItem({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.image,
    required this.description,
    required this.count,
  });
}
