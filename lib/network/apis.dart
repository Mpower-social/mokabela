class Apis{
  static var AUTH = "Authorization";


  //static var url = 'http://192.168.19.19:3008';//dev
  //static var url = 'https://msurvey-api.dev.mpower-social.com';//dev
  static var url = 'https://msurvey-api.demo.mpower-social.com';//dev
  //static var url = 'http://192.168.22.59:3000';//local imam
  //static var url = 'http://192.168.23.89:3000';//local tanvir

  //static var odkRelatedUrl = 'http://192.168.19.16:9037';//dev
  //static var odkRelatedUrl = 'http://192.168.19.16:8092/';//dev
  //static var odkRelatedUrl = 'http://192.168.19.16:9037';//dev
  //static var odkRelatedUrl = 'https://msurvey-product.dev.mpower-social.com';//dev
  static var odkRelatedUrl = 'https://msurvey-product.demo.mpower-social.com';//dev
  //static var odkRelatedUrl = 'http://192.168.22.59:8111';//local


  static var baseUrl = '$url/msurvey/api';//dev

  static var login = '$baseUrl/auth/login';
  static var refreshToken = '$baseUrl/auth/refresh-token';
  static getProjectList(orgId) => '$baseUrl/project/get-project-by-orgId?orgId=$orgId';
  static getUserByUserName(userName) => '$baseUrl/user/get-user-by-username?username=$userName';
  static var getFormList = '$baseUrl/project/forms/get-form-list-all';
  static var getAllFormList = '$baseUrl/project/forms/get-all-form-configuration';
  static var getSubmittedFormList = '$odkRelatedUrl/msurvey/forms/instance/list/';
  static var getRevertedFormList = '$baseUrl/project/forms/get-all-reverted-instances';
  static var submitForm = '$odkRelatedUrl/msurvey/forms/instance/submit/';
}