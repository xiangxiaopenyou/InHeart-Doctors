//
//  CommonsDefines.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CommonsDefines.h"
NSString * const USERID = @"UserId";
NSString * const USERTOKEN = @"UserToken";
NSString * const USERCODE = @"UserCode";
NSString * const USERREALNAME = @"Realname";
NSString * const USERNAME = @"Username";
NSString * const KEYCHAINSERVICE = @"com.midvision.vrdoctor";


CGFloat const TABBARHEIGHT = 49.0;
CGFloat const NAVIGATIONBARHEIGHT = 64.0;

NSString * const kSearchPlaceholder = @"请输入你要搜索的内容";
NSString * const kAllDiseases = @"全部病种";
NSString * const kAllContents = @"全部内容";
NSString * const kAllTherapies = @"全部疗法";

NSString * const kMyInterrogation = @"我的问诊";
NSString * const kMyWallet = @"我的钱包";
NSString * const kMyDoctors = @"我的医生";
NSString * const kMyCollections = @"我的收藏";
NSString * const kMyAccount = @"我的账户";
NSString * const kHelpAndFeedback = @"帮助与反馈";
NSString * const kPersonalSetting = @"设置";
NSString * const kInterrogationSetting = @"问诊设置";
NSString * const kClearCache = @"清除缓存";
NSString * const kAboutUs = @"关于";

NSString * const kInputPhoneNumber = @"请输入您的手机号";
NSString * const kInputPassword = @"请输入您的密码";
NSString * const kInputVerificationCode = @"请输入验证码";
NSString * const kInputPasswordAgain = @"请再次输入您的密码";
NSString * const kUserAgreement = @"用户协议";
NSString * const kFetchVerificationCode = @"获取验证码";
NSString * const kInputCorrectPhoneNumberTip = @"请输入正确的手机号";
NSString * const kInputPasswordTip = @"请输入密码";
NSString * const kPasswordFormatTip = @"密码要求是6-16位数字、字母和符号任意两种的组合";
NSString * const kDifferentPasswordTip = @"两次密码输入不一致";
NSString * const kInputVerificationCodeTip = @"请输入收到的验证码";
NSString * const kPleaseEnsureInformation = @"请确认以下信息准确";
NSString * const kNameTitle = @"姓名";
NSString * const kIDCardTitle = @"身份证";
NSString * const kPleaseInputRealname = @"请输入您的真实姓名";
NSString * const kPleaseInputIDCardNumber = @"请输入您的身份证号";
NSString * const kCameraNotAvailable = @"您的设备不支持拍照";
NSString * const kAppCameraAccessNotAuthorized = @"请在“设置-隐私-相机”选项中允许心景访问您的相机";
NSString * const kAppPhotoLibraryAccessNotAuthorized = @"请在“设置-隐私-照片”选项中允许心景访问您的相册";
NSString * const kPleaseUploadAuthenticationPicture = @"请先上传医生资格证照片";
NSString * const kPleaseInputCorrectIDCardNumber = @"请输入正确的身份证号";
NSString * const kKeepWaiting = @"等待认证";
NSString * const kAuthenticationFail = @"认证失败";
NSString * const kAuthenticationFailed = @"认证失败！";
NSString * const kWaitingForAuthentication= @"已提交审核资料 请耐心等待！";
NSString * const kFindPassword = @"找回密码";
NSString * const kChangePassword = @"修改密码";

NSString * const kLoginSuccess = @"LoginSuccess";
NSString * const kApplicationBecomeActive = @"ApplicationBecomeActive";

NSString * const BASEAPIURL = @"http://xj.dosnsoft.com:8000/api/v1/";

NSString * const USER_LOGIN = @"doctor/login";
NSString * const USER_REGISTER = @"doctor/register";
NSString * const USER_AUTHENTICATION = @"doctor/auth";
NSString * const UPLOAD_AUTHENTICATION_IMAGE = @"doctor/authUpload";
NSString * const FETCH_VERIFICATION_CODE = @"doctor/sendCode";
NSString * const FIND_PASSWORD = @"doctor/modifyPassword";

NSString * const FETCH_CONTENTS_LIST = @"doctor/content/search";
NSString * const FETCH_CONTENTS_TYPES = @"doctor/content/type";
NSString * const FETCH_DISEASES = @"doctor/content/disease";
NSString * const FETCH_THERAPIES = @"doctor/content/therapy";
NSString * const FETCH_CONTENT_DETAIL = @"doctor/content/info";

NSString * const FETCH_COLLECTIONS_LIST = @"doctor/contentCollect/search";
