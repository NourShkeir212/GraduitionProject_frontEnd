class AppConstants {


  //Base Router Url
  static String BASE_URL = "http://192.168.1.41:8001/";

  //Base Data Url
  //static String BASE_URL = "http://192.168.42.69:8001/";

  //AUTH
  static String REGISTER = "api/auth/user/register";
  static String LOGIN = "api/auth/user/login";
  static String LOGOUT_CURRENT_SESSION = "api/auth/user/logout_current_session";
  static String LOGOUT_ALL_SESSION = "api/auth/user/logout_all_sessions";

  //User Profile
  static String PROFILE = "api/user/get_profile";
  static String UPDATE_PROFILE = "api/user/update_profile";
  static String CHANGE_PASSWORD = "api/user/change_password";
  static String DELETE_ACCOUNT = "api/user/delete_account";

  //PROFILE IMAGE
  static String UPLOAD_PROFILE_IMAGE = "api/user/upload_profile_image";
  static String UPDATE_PROFILE_IMAGE = "api/user/update_profile_image";
  static String DELETE_PROFILE_IMAGE = "api/user/delete_profile_image";

  //CATEGORIES
  static String GET_CATEGOREIS = "api/user/get_categories";
  static String GET_CATEGOREIS_DETAILS = "api/user/categories/{id}/workers";
  static String GET_POPULAR_CATEGORIES = "api/user/popular-categories";

  //ADD TO FAVORITES
  static String ADD_TO_FAVORITES = "api/user/add_to_favorites";
  static String GET_FAVORITES = "api/user/get_favorites";
  static String DELETE_FROM_FAVORITES = "api/user/delete_from_favorite/{id}";

  //GET_REVIEWS
  static String GET_USERS_REVIEWS = "api/user/worker/reviews/{id}";
  static String UPLOAD_REVIEW = "api/user/upload_review";

  //TASKS
  static String GET_TASKS = "api/user/get_tasks";
  static String CREATE_TASK = "api/user/create_task";
  static String DELETE_TASK = "api/user/delete_task/{id}";
  static String DELETE_ALL_COMPLETED_TASKS = "api/user/delete_completed_tasks";

  //WORKER PROFILE
  static String GET_WORKER = "api/user/worker/get_profile/{id}";
  static String GET_TOP_RATED_WORKERS = "api/user/top-rated-workers";

  //SEARCH

  static String SEARCH = 'api/user/workers/search';

  //-------------------------------Assets Files---------------------------------//
  static String LOGO_WITH_TEXT_URL = "assets/images/in_app_images/app_logo.png";
  static String LOGO_WITHOUT_TEXT_URL = "assets/images/in_app_images/logo_without_text.png";

}