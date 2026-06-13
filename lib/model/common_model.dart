class CommonModel {
  CommonModel({
    this.name,
    this.price,
    this.title,
    this.subTitle,
    this.address,
    this.code,
    this.profileImage,
    this.icon,
    this.subIcon,
    this.des,
  });

  String? name;
  String? title;
  String? subTitle;
  String? address;
  String? code;
  String? price;
  String? profileImage;
  String? icon;
  String? des;
  String? subIcon;
}

class ChartData {
  ChartData({this.label, this.value});

  final String? label;
  final String? value;

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}
