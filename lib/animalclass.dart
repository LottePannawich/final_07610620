class animal{
  final String image;
  final String answer;
  final List choice_list;

  animal({
    required this.image,
    required this.answer,
    required this.choice_list,
  });

  factory animal.fromJson(Map<String, dynamic> json) {
    return animal(
      image:  json["image"],
      answer:   json["answer"],
      choice_list:   (json['choice_list'] as List).map((choice) => choice).toList() ,
    );
  }
}









