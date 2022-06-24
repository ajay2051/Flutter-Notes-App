import 'dart:convert';
import 'dart:ui';

class NoteModel{
  int? id;
  String? title;
  String? description;
  String? dateCreated;
  NoteModel({  this.id, this.title, this.description, this.dateCreated});

// function to convert item into Map

  Map<String, dynamic> toMap(){

    return ({
      'id': id,
      'title': title,
      'description': description,
      'dateCreated': dateCreated.toString()
    });
  }
  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dateCreated = json['dateCreated'];
  }
}