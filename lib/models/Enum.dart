enum FetchResult{
  SUCCESS,
  EMPTY,
  ERROR_OCCURED,
  FETCHING_IN_PROGRESS
}
enum FetchState{
  FETCHING_IN_PROGRESS,
  FETCHING_COMPLETED,
  FETCHING_FAILED,
}
enum SearchingFor{
  ATTENDENT,
  PARENT,
  USER
}
enum Relation{
  ATTENDENT,
  USER
}
enum UserStateInJourney{
  JOINED,
  PENDING,
  NOT_JOINED,
}



/*
Data base collections
journies_users{
  role: ADMIN - USER - PARENT
}
notifications{
  type : JOURNEY_INVITATION - ATTENDENCE_REQUEST - PARENT_REQUEST - JOIN_JOURNEY_REQUEST
}
users{
   'token': "NO_TOKEN" - or a token from user device
}
*/