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



/*
Data base collections
journies_users{
  role: ADMIN - USER
}
notifications{
  type : JOURNEY_INVITATION - ATTENDENCE_REQUEST
}
*/