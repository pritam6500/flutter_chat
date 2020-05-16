class UserModel {
   int userId;
   String socketId;
   String name;
   String userType;
   int isCurrentUser;
   String avatarUrl;
  UserModel({this.userId
  , this.socketId, this.name, this.userType, this.isCurrentUser, this.avatarUrl});

  Map<String,dynamic> toMap(){
    final map= Map<String,dynamic>();
    map['userId']=this.userId ?? null;
    map['socketId']=this.socketId ?? '';
    map['name']=this.name;
    map['userType']=this.userType;
    map['isCurrentUser']=this.isCurrentUser;
    map['avatarUrl']=this.avatarUrl??'';
    return map;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {

  return UserModel(
     userId : int.parse(json['userId'].toString()),
    socketId : json['socketId'],
    name : json['name'].toString(),
    userType : json['userType']??'customer',
    isCurrentUser:json['isCurrentUser']??0,
    avatarUrl : json['avatarUrl']??'');
  
  }

  static List encondeToJson(List<UserModel>list){
    List jsonList = List();
    list.map((item)=>
      jsonList.add(item.toMap())
    ).toList();
    return jsonList;
}

}

