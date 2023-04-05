import 'package:mongo_dart/mongo_dart.dart' ;
import 'package:doctor/user.dart';
import 'package:provider/provider.dart';
import 'package:doctor/userProvider.dart';
const url="mongodb+srv://jerrito0240:streak0240845898@cluster0.5dpfja6.mongodb.net/ayaresapa?retryWrites=true&w=majority";
const collection="ayaresapaAccount";
const collectionAppointment="ayaresapaAppointment";
class mongo{
static var db, doctorCollection,appointmentCollection;
  static con() async{
    db = await Db.create(url);
    await db.open();
   // Db.inspect(db);
     doctorCollection=db.collection(collection);
    appointmentCollection=db.collection(collectionAppointment);
  }
static Future<List<Map<String,dynamic>>> getAppointment() async{
  var findDoc= await appointmentCollection.find().toList();
  return findDoc;
}
static Future update(String Key,dynamic val,String newKey,dynamic newVal)async{
  await mongo.con();
 var updates=await mongo.doctorCollection.updateOne(where.eq(Key, val),
     ModifierBuilder().set(newKey, newVal));
  print('Modified documents: ${updates.nModified}');
 return updates;
}
static Future<String> insertDoctorDetail({required User user})async{
    try{

      var result=await doctorCollection.insertOne(user.toJson());
      if (result.success){
        return "Success";}
      else{return "failed";
      }}
    catch(e){
      print(e);
      return e.toString();}}





}

