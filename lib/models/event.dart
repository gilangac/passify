class EventModel {
  String? category;
  String? description;
  String? name;
  String? idEvent;
  String? idUser;
  String? date;
  String? location;
  String? time;
  String? dateEvent;
  List? member;

  EventModel(
      {this.category,
      this.description,
      this.name,
      this.idEvent,
      this.idUser,
      this.date,
      this.location,
      this.time,
      this.dateEvent,
      this.member});
}
