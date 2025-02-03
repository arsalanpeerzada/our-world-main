class ApiEndPoints {
  static const SIGNUP = "auth/signup";
  static const LOGIN = "auth/login";
  static const CREATEPOST = "post/createPost";
  static const GETPOST = "post/getAllPost";
  static const POSTCOMMENTS = "posts/comments";
  static const GETCOMMENTS = "posts/comments";
  static const GETPOSTBYID = "post/getPostById";
  static const GETPOSTBYFILTER = "post/getAllPostByCategory";
  static const DELETEPOST = "post/deletePost";
  static const SENDOTP = "otp/send";
  static const VERIFYOTP = "otp/verify";

}

class BaseURL {
  static const BASEURL = "http://50.17.75.6:8080/api/";
}
