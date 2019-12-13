import 'package:safe_journey/models/journey_search_element.dart';

import '../models/user.dart';
import 'package:rxdart/subjects.dart' as rx;

class Global {
  static User user;
  static bool visitedWaitingPage = false;
  static int notificationsCount = 5;
  static rx.PublishSubject<int> notificationObservable;
  static rx.PublishSubject<bool> loadingObservable;
  //for header
  static List<JourneySearchElement> allJournies;
  static List<String> joinedJournies;
  static List<String> pendingJournies;
  //********** *
  static closeNotificationObservable() {
    notificationObservable.close();
  }

  static closeLoadingObservable() {
    loadingObservable.close();
  }
}
