class AppImages {
  AppImages._();

  static const String fruits = "https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400&q=80";
  static const String vegetables = "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&q=80";
  static const String grains = "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80";
  static const String dairy = "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80";
  static const String herbs = "https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80";
  static const String poultry = "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&q=80";

  static const String banner1 = "https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800&q=80";
  static const String banner2 = "https://images.unsplash.com/photo-1550989460-0adf4f622d9b?w=800&q=80";
  static const String banner3 = "https://images.unsplash.com/photo-1590779033100-9d1a6b41510b?w=800&q=80";

  static const String farmer1 = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80";
  static const String farmer2 = "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=200&q=80";
  static const String farmer3 = "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80";
  static const String farmer4 = "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80";

  static const String mango = "https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80";
  static const String tomato = "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80";
  static const String strawberry = "https://images.unsplash.com/photo-1518635017498-87f514b751ba?w=400&q=80";
  static const String rice = "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80";
  static const String milk = "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80";
  static const String apple = "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&q=80";
  static const String onion = "https://images.unsplash.com/photo-1508747703725-719777637510?w=400&q=80";
  static const String spinach = "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80";
  static const String bananas = "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&q=80";
  static const String grapes = "https://images.unsplash.com/photo-1596363505723-1942bFD6c4f4?w=400&q=80";
  static const String pomegranate = "https://images.unsplash.com/photo-1541344999736-b83e4c0e7f32?w=400&q=80";
  static const String papaya = "https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400&q=80";
  static const String potatoes = "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80";
  static const String brinjals = "https://images.unsplash.com/photo-1615484477778-ca3b77940c25?w=400&q=80";
  static const String cabbage = "https://images.unsplash.com/photo-1551884170-09fb70a3a2ed?w=400&q=80";
  static const String toorDal = "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80";
  static const String wheat = "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&q=80";
  static const String curd = "https://images.unsplash.com/photo-1628082876465-ed2d1619152f?w=400&q=80";
  static const String ghee = "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&q=80";
  static const String mint = "https://images.unsplash.com/photo-1628556271670-6efa96de7b5d?w=400&q=80";
  static const String coriander = "https://images.unsplash.com/photo-1593853761646-0f2e5765d9b5?w=400&q=80";
  static const String eggs = "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400&q=80";
  static const String chicken = "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&q=80";

  static const Map<String, String> categoryImages = {
    "Fruits": fruits,
    "Vegetables": vegetables,
    "Grains": grains,
    "Dairy": dairy,
    "Herbs": herbs,
    "Poultry": poultry,
  };

  static const Map<String, String> productImages = {
    "Fresh Mangoes": mango,
    "Organic Tomatoes": tomato,
    "Strawberries": strawberry,
    "Basmati Rice": rice,
    "Fresh Milk": milk,
    "Green Chillies": "https://images.unsplash.com/photo-1583101313954-751c8b5b6ef3?w=400&q=80",
    "Red Apples": apple,
    "Fresh Onions": onion,
    "Spinach": spinach,
    "Organic Bananas": bananas,
    "Fresh Grapes": grapes,
    "Pomegranate": pomegranate,
    "Papaya": papaya,
    "Potatoes": potatoes,
    "Brinjals": brinjals,
    "Cabbage": cabbage,
    "Toor Dal": toorDal,
    "Whole Wheat": wheat,
    "Curd": curd,
    "Ghee": ghee,
    "Fresh Mint": mint,
    "Coriander": coriander,
    "Farm Eggs": eggs,
    "Chicken": chicken,
  };

  static const List<String> farmerImages = [farmer1, farmer2, farmer3, farmer4];

  static String forProduct(String name) {
    return productImages.entries
        .firstWhere((e) => name.toLowerCase().contains(e.key.toLowerCase()), orElse: () => const MapEntry("", vegetables))
        .value;
  }

  static String forCategory(String category) {
    return categoryImages[category] ?? fruits;
  }
}
