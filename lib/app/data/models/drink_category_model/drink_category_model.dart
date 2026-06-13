class DrinkCategoryData {
  DrinkCategoryData({
    this.sId,
    this.name,
    this.description,
    this.image,
    this.imageThumb,
    this.sortOrder,
  });

  factory DrinkCategoryData.fromJson(Map<String, dynamic> json) {
    return DrinkCategoryData(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      imageThumb: json['imageThumb'] as String?,
      sortOrder: json['sortOrder'] as num?,
    );
  }

  String? sId;
  String? name;
  String? description;
  String? image;
  String? imageThumb;
  num? sortOrder;
}
