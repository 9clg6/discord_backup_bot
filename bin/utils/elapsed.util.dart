///
/// Return string corresponding to the elapsed time in seconds, minuts or hours
///
String elapsedString(Duration e){
  String? elapsed;
  
  if(e.inMinutes == 0){
    elapsed = "${e.inSeconds} secondes";
  } else if(e.inMinutes > 0 && e.inMinutes <= 60){
    elapsed = "${e.inMinutes} minutes";
  } else {
    elapsed = "${e.inHours} heures";
  }
  
  return elapsed;
}