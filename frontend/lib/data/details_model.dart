class DetailsModel {
  final bool price;
  final String use;
  final String wastetype;
  final int id;
  final bool place;
  final String title;

  bool placed = false;

  DetailsModel(
      this.price, this.use, this.wastetype, this.id, this.place, this.title);

  bool getAllowedToRecycle() {
    return place;
  }

  bool getFreeToRecycle() {
    return !price;
  }

  String getCategoryName() {
    if (wastetype == null) {
      return "Muu jäte";
    }
    return wastetype;
  }

  int getCategoryId() {
    return id;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return use;
  }

  static DetailsModel from(Map<String, dynamic> data, {String title}) {
    return DetailsModel(data["price"] as bool, data["use"], data["wastetype"],
        data["id"], data["place"] as bool, title);
  }

  void togglePlaced() {
    placed = !placed;
  }
}
