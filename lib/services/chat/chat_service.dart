import 'package:chitchat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{
  //get instance of firestore & auth
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        //go through each individual user
        final user = doc.data();

        //return user
        return user;

      }).toList(); 
    });
  }
  //send msg
  Future<void> sendMessage(String receiverID, String message) async {
  // Get current user info
  final String currentUserID = _auth.currentUser!.uid;
  final String currentUserEmail = _auth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();

  // Create a new message
  Message newMessage = Message(
    senderID: currentUserID,
    senderEmail: currentUserEmail,
    receiverID: receiverID,
    message: message,
    timestamp: timestamp,
    // Add a field to indicate the request status (pending, accepted, rejected)
  );

  // Construct a chat room for the two users (sorted to ensure uniqueness)
  List<String> ids = [currentUserID, receiverID];
  ids.sort(); // Sorts the ids (ensure the chatroomID is the same for the 2 users)
  String chatroomID = ids.join("_");

  // Add new message to database
  await _firestore
      .collection("chat_rooms")
      .doc(chatroomID)
      .collection("messages")
      .add(newMessage.toMap());

  // Update the receiver's connection requests collection with the new request
  await _firestore
      .collection("users")
      .doc(receiverID)
      .collection("connection_requests")
      .doc(chatroomID)
      .set({
    'senderID': currentUserID,
    'timestamp': timestamp,
    'requestStatus': 'pending',
  });
}

  //get msg
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    //construct chatroomID for the two uses
    List<String> ids= [userID,otherUserID];
    ids.sort();
    String chatroomID = ids.join("_");

    return _firestore
    .collection("chat_rooms")
    .doc(chatroomID)
    .collection("messages")
    .orderBy("timestamp",descending: false)
    .snapshots();
  }

  Stream<QuerySnapshot> getConnectionRequestsStream() {
    String currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("connection_requests")
        .snapshots();
  }

  Future<void> acceptConnectionRequest(String requestID) async {
    String currentUserID = _auth.currentUser!.uid;
    DocumentSnapshot requestSnapshot = await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("connection_requests")
        .doc(requestID)
        .get();

    String senderID = requestSnapshot['senderID'];
    String chatroomID = requestID;

    // Update the request status to accepted
    await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("connection_requests")
        .doc(requestID)
        .update({'requestStatus': 'accepted'});

    // Create a new chat room document or update an existingchat room document with the accepted request
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .set({'users': [currentUserID, senderID]});

    // Remove the connection request from the receiver's collection
    await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("connection_requests")
        .doc(requestID)
        .delete();
  }

  Future<void> rejectConnectionRequest(String requestID) async {
    String currentUserID = _auth.currentUser!.uid;

    // Remove the connection request from the receiver's collection
    await _firestore
        .collection("users")
        .doc(currentUserID)
        .collection("connection_requests")
        .doc(requestID)
        .delete();
  }

}