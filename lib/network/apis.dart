class Apis{
  static var AUTH = "Authorization";


  static var url = 'http://192.168.19.19:3008';
  //static var url = 'http://192.168.22.218:3002/';
  static var baseUrl = '$url/msurvey/api';//dev

  static var login = '$baseUrl/auth/login';
  static getProjectList(orgId,currentPage,pageSize) => '$baseUrl/project/get-project-by-orgId?orgId=$orgId&currentPage=$currentPage&pageSize=$pageSize';
  static getUserByUserName(userName) => '$baseUrl/user/get-user-by-username?username=$userName';
}