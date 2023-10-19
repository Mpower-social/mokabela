class Apis{
  static var AUTH = "Authorization";


  //static var url = 'http://192.168.19.19:3008';//dev
  static var qa = 'https://msurvey-api.qa.mpower-social.com';//qa
 // static var dev = 'https://msurvey-api.dev.mpower-social.com';//dev
  static var local = 'https://msurvey-api.demo.mpower-social.com';//dev
  static var live = 'https://msurvey-api.mpower-social.com';//dev
  //static var url = 'http://192.168.22.59:3000';//local imam
  //static var url = 'http://192.168.23.89:3000';//local tanvir

  //static var odkRelatedUrl = 'http://192.168.19.16:9037';//dev
  //static var odkRelatedUrl = 'http://192.168.19.16:8092/';//dev
  //static var odkRelatedUrl = 'http://192.168.19.16:9037';//dev
  static var odkRelatedUrlQa = 'https://msurvey-product.qa.mpower-social.com';//qa
  //static var odkRelatedUrlDev = 'https://msurvey-product.dev.mpower-social.com';//dev
  static var odkRelatedUrlDemo = 'https://msurvey-product.demo.mpower-social.com';//demo
  static var odkRelatedUrlLive = 'https://msurvey-product.mpower-social.com';//demo
  //static var odkRelatedUrl = 'http://192.168.22.59:8111';//local


  static var baseUrl = '$qa/msurvey/api';//dev

  static var login = '$baseUrl/auth/login';
  static var refreshToken = '$baseUrl/auth/refresh-token';
  static getProjectList(orgId) => '$baseUrl/project/get-project-by-orgId?orgId=$orgId';
  static getUserByUserName(userName) => '$baseUrl/user/get-user-by-username?username=$userName';
  static var getFormList = '$baseUrl/project/forms/get-form-list-all';
  static var getAllFormList = '$baseUrl/project/forms/get-all-form-configuration';
  static var getSubmittedFormList = '$odkRelatedUrlQa/msurvey/forms/instance/list/';
  static var getRevertedFormList = '$baseUrl/project/forms/get-all-reverted-instances';
  static var submitForm = '$odkRelatedUrlQa/msurvey/forms/instance/submit/';
}