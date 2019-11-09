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



/*
Data base collections
journies_users{
  role: ADMIN - USER
}
notifications{
  type : JOURNEY_INVITATION - ATTENDENCE_REQUEST - PARENT_REQUEST
}
*/