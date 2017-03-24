//
//  CommonsDefines.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CommonsDefines.h"

NSString * const EMChatKey = @"1109161016178876#xinjing";
NSString * const APNSCertName = @"InHeart-Doctor-Dev";
//NSString * const APNSCertName = @"InHeart-Doctor-Dis";

NSString * const USERID = @"UserId";
NSString * const USERTOKEN = @"UserToken";
NSString * const USERCODE = @"UserCode";
NSString * const USERREALNAME = @"Realname";
NSString * const USERNAME = @"Username";
NSString * const USERENCRYPTEDPASSWORD = @"EncryptedPassword";
NSString * const KEYCHAINSERVICE = @"com.midvision.vrdoctor";
NSString * const FIRSTLOAD = @"FirstLoad";
NSString * const LAST_RUN_VERSION = @"last_run_version";


CGFloat const TABBARHEIGHT = 49.0;
CGFloat const NAVIGATIONBARHEIGHT = 64.0;

NSString * const kSearchPlaceholder = @"请输入你要搜索的内容";
NSString * const kAllDiseases = @"全部病种";
NSString * const kAllContents = @"全部内容";
NSString * const kAllTherapies = @"全部疗法";
NSString * const kVideoCanNotPlay = @"视频无法播放";
NSString * const kNetworkError = @"网络错误";

NSString * const kCommonTip = @"提示";
NSString * const kCommonCancel = @"取消";
NSString * const kCommonEnsure = @"确定";
NSString * const kIsMakePhoneCall = @"打电话给患者？";
NSString * const kPleaseInputPrescriptionWords = @"请先写好医嘱哦~";
NSString * const kIsFree = @"确定发送免费处方吗？";

NSString * const kMyInterrogation = @"我的问诊";
NSString * const kMyWallet = @"我的钱包";
NSString * const kMyDoctors = @"我的医生";
NSString * const kMyCollections = @"我的收藏";
NSString * const kMyPatients = @"我的患者";
NSString * const kMyBandCard = @"我的银行卡";
NSString * const kInviteDoctors = @"邀请医生";
NSString * const kMyAccount = @"我的账户";
NSString * const kHelpAndFeedback = @"帮助与反馈";
NSString * const kPersonalSetting = @"设置";
NSString * const kInterrogationSetting = @"问诊设置";
NSString * const kTelephoneNumber = @"手机号";
NSString * const kChangePassword = @"修改密码";
NSString * const kCheckNewVersion = @"检测新版本";
NSString * const kServiceAgreement = @"服务协议";
NSString * const kClearCache = @"清除缓存";
NSString * const kAboutUs = @"关于";
NSString * const kMySpecialits = @"我的擅长";
NSString * const kMyCity = @"我的城市";
NSString * const kStopInterrogationTip = @"停止问诊患者将无法联系您";

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

NSString * const kLoginSuccess = @"LoginSuccess";
NSString * const kApplicationBecomeActive = @"ApplicationBecomeActive";
NSString * const kSetupUnreadMessagesCount = @"SetupUnreadMessagesCount";
NSString * const kConversationsDidChange = @"ConversationsDidChange";

NSString * const BASEAPIURL = @"http://test.med-vision.cn/api/v1/";

NSString * const USER_LOGIN = @"doctor/login";
NSString * const USER_REGISTER = @"doctor/register";
NSString * const USER_AUTHENTICATION = @"doctor/auth";
NSString * const UPLOAD_AUTHENTICATION_IMAGE = @"doctor/authUpload";
NSString * const UPLOAD_TITLES_IMAGE = @"doctor/authTitleUpload";
NSString * const FETCH_VERIFICATION_CODE = @"doctor/sendCode";
NSString * const FIND_PASSWORD = @"doctor/modifyPassword";
NSString * const USER_LOGOUT = @"doctor/logout";

NSString * const FETCH_CONTENTS_LIST = @"doctor/content/search";
NSString * const FETCH_CONTENTS_TYPES = @"doctor/content/type";
NSString * const FETCH_DISEASES = @"doctor/content/disease";
NSString * const FETCH_THERAPIES = @"doctor/content/therapy";
NSString * const FETCH_CONTENT_DETAIL = @"doctor/content/info";
NSString * const COLLECT_CONTENT = @"doctor/content/collect";
NSString * const CANCEL_COLLECT_CONTENT = @"doctor/content/cancelCollect";

NSString * const FETCH_COLLECTIONS_LIST = @"doctor/contentCollect/search";
NSString * const FETCH_PERSONAL_INFORMATION = @"doctor/getInfo";
NSString * const FETCH_ACCOUNT_BALANCE = @"doctor/getBalance";
NSString * const FETCH_BILL_LIST = @"doctor/getBills";
NSString * const FETCH_CITIES_LIST = @"doctor/getRegion";
NSString * const EDIT_INFORMATION = @"doctor/fillInfo";
NSString * const UPLOAD_AVATAR = @"doctor/headPictureUpload";
NSString * const FETCH_BILLS_LIST = @"doctor/getBills";
NSString * const FETCH_COMMON_PRICE = @"doctor/getMinPrice";
NSString * const SET_COMMON_PRICE = @"doctor/setMinPrice";
NSString * const SET_INTERROGATION_STATE = @"doctor/setStatus";

NSString * const FETCH_USERS_NAME = @"doctor/getUserIDAndName";
NSString * const SEND_PRESCRIPTION = @"doctor/prescription/add";
