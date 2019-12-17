import 'package:safe_journey/models/journey_search_element.dart';
import '../models/user.dart';
import 'package:rxdart/subjects.dart' as rx;

class Global {
  static User user;
  static bool visitedWaitingPage = false;
  //for notifications
  static int notificationsCount = 5;
  static rx.PublishSubject<int> notificationObservable;
  static rx.PublishSubject<bool> loadingObservable;
  //for header search for journey
  static List<JourneySearchElement> allJournies;
  static List<String> joinedJournies;
  static List<String> pendingJournies;
  static int numberOfcurrentFetchedJournies=0;
  //for realtime screen

  //for notifications
  static closeNotificationObservable() {
    notificationObservable.close();
  }

  static closeLoadingObservable() {
    loadingObservable.close();
  }

  
}
