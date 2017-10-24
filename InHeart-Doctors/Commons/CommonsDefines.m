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
NSString * const USERAVATARDATA = @"UserAvatarData";
NSString * const USERAVATARSTRING = @"UserAvatarString";
NSString * const USERENCRYPTEDPASSWORD = @"EncryptedPassword";
NSString * const KEYCHAINSERVICE = @"com.midvision.vrdoctor";
NSString * const FIRSTLOAD = @"FirstLoad";
NSString * const LAST_RUN_VERSION = @"last_run_version";


CGFloat const TABBARHEIGHT = 49.0;
CGFloat const NAVIGATIONBARHEIGHT = 64.0;

NSString * const XJSearchPlaceholder = @"请输入你要搜索的内容";
NSString * const XJAllDiseases = @"全部病种";
NSString * const XJAllContents = @"全部内容";
NSString * const XJAllTherapies = @"全部疗法";
NSString * const XJVideoCanNotPlay = @"视频无法播放";
NSString * const XJNetworkError = @"网络错误";

NSString * const XJCommonTip = @"提示";
NSString * const XJCommonCancel = @"取消";
NSString * const XJCommonEnsure = @"确定";
NSString * const XJIsMakePhoneCall = @"打电话给患者？";
NSString * const XJPleaseInputPrescriptionWords = @"请先写好医嘱";
NSString * const XJIsFree = @"确定发送免费处方吗？";

NSString * const XJMyInterrogation = @"我的问诊";
NSString * const XJMyOrders = @"我的订单";
NSString * const XJMyWallet = @"我的钱包";
NSString * const XJMyDoctors = @"我的医生";
NSString * const XJMyCollections = @"我的收藏";
NSString * const XJMyPatients = @"我的患者";
NSString * const XJMyBandCard = @"我的银行卡";
NSString * const XJMyScores = @"我的积分";
NSString * const XJInviteDoctors = @"邀请医生";
NSString * const XJInvitePatients = @"邀请患者";
NSString * const XJMyAccount = @"我的账户";
NSString * const XJHelpAndFeedback = @"帮助与反馈";
NSString * const XJPersonalSetting = @"设置";
NSString * const XJInterrogationSetting = @"问诊设置";
NSString * const XJTelephoneNumber = @"手机号";
NSString * const XJChangePassword = @"修改密码";
NSString * const XJCheckNewVersion = @"检测新版本";
NSString * const XJServiceAgreement = @"服务协议";
NSString * const XJClearCache = @"清除缓存";
NSString * const XJAboutUs = @"关于";
NSString * const XJMySpecialits = @"我的擅长";
NSString * const XJMyCity = @"我的城市";
NSString * const XJStopInterrogationTip = @"停止问诊患者将无法联系您";

NSString * const XJInputPhoneNumber = @"请输入您的手机号";
NSString * const XJInputPassword = @"请输入您的密码";
NSString * const XJInputVerificationCode = @"请输入验证码";
NSString * const XJInputPasswordAgain = @"请再次输入您的密码";
NSString * const XJUserAgreement = @"用户协议";
NSString * const XJFetchVerificationCode = @"获取验证码";
NSString * const XJInputCorrectPhoneNumberTip = @"请输入正确的手机号";
NSString * const XJInputPasswordTip = @"请输入密码";
NSString * const XJPasswordFormatTip = @"密码要求是6-16位数字、字母和符号任意两种的组合";
NSString * const XJDifferentPasswordTip = @"两次密码输入不一致";
NSString * const XJInputVerificationCodeTip = @"请输入收到的验证码";
NSString * const XJPleaseEnsureInformation = @"请确认以下信息准确";
NSString * const XJNameTitle = @"姓名";
NSString * const XJIDCardTitle = @"身份证";
NSString * const XJPleaseInputRealname = @"请输入您的真实姓名";
NSString * const XJPleaseInputIDCardNumber = @"请输入您的身份证号";
NSString * const XJCameraNotAvailable = @"您的设备不支持拍照";
NSString * const XJAppCameraAccessNotAuthorized = @"请在“设置-隐私-相机”选项中允许心景访问您的相机";
NSString * const XJAppPhotoLibraryAccessNotAuthorized = @"请在“设置-隐私-照片”选项中允许心景访问您的相册";
NSString * const XJPleaseUploadAuthenticationPicture = @"请先上传医生资格证照片";
NSString * const XJPleaseInputCorrectIDCardNumber = @"请输入正确的身份证号";
NSString * const XJKeepWaiting = @"等待认证";
NSString * const XJAuthenticationFail = @"认证失败";
NSString * const XJAuthenticationFailed = @"认证失败！";
NSString * const XJWaitingForAuthentication= @"已提交审核资料 请耐心等待！";
NSString * const XJFindPassword = @"找回密码";

NSString * const XJLoginSuccess = @"LoginSuccess";
NSString * const XJApplicationBecomeActive = @"ApplicationBecomeActive";
NSString * const XJSetupUnreadMessagesCount = @"SetupUnreadMessagesCount";
NSString * const XJConversationsDidChange = @"ConversationsDidChange";

NSString * const BASEAPIURL = @"http://test.med-vision.cn/api/v1/";
NSString * const ADVICEBASEURL = @"http://test.med-vision.cn/h5/help/";

NSString * const USER_LOGIN = @"doctor/login";
NSString * const USER_REGISTER = @"doctor/register";
NSString * const USER_AUTHENTICATION = @"doctor/auth";
NSString * const UPLOAD_AUTHENTICATION_IMAGE = @"doctor/authUpload";
NSString * const UPLOAD_TITLES_IMAGE = @"doctor/authTitleUpload";
NSString * const FETCH_VERIFICATION_CODE = @"doctor/sendCode";
NSString * const FIND_PASSWORD = @"doctor/modifyPassword";
NSString * const USER_LOGOUT = @"doctor/logout";
NSString * const FETCH_BASIC_INFORMATIONS = @"doctor/homepage/contents";
NSString * const CHANGE_PASSWORD = @"doctor/modifyPassword";

NSString * const FETCH_CONTENTS_LIST = @"doctor/content/search";
NSString * const FETCH_CONTENTS_TYPES = @"doctor/content/type";
NSString * const FETCH_DISEASES = @"doctor/content/disease";
NSString * const FETCH_THERAPIES = @"doctor/content/therapy";
NSString * const FETCH_CONTENT_DETAIL = @"doctor/content/info";
NSString * const COLLECT_CONTENT = @"doctor/content/collect";
NSString * const CANCEL_COLLECT_CONTENT = @"doctor/content/cancelCollect";

NSString * const FETCH_COLLECTIONS_LIST = @"doctor/contentCollect/search";
NSString * const FETCH_PERSONAL_INFORMATION = @"doctor/getInfo";
NSString * const FETCH_ACCOUNT_BALANCE = @"doctor/myWallet";
NSString * const FETCH_BILL_LIST = @"doctor/receivableBills";
NSString * const FETCH_CITIES_LIST = @"doctor/getRegion";
NSString * const EDIT_INFORMATION = @"doctor/fillInfo";
NSString * const UPLOAD_AVATAR = @"doctor/headPictureUpload";
NSString * const FETCH_BILLS_LIST = @"doctor/getBills";
NSString * const FETCH_COMMON_PRICE = @"doctor/getMinPrice";
NSString * const SET_COMMON_PRICE = @"doctor/setMinPrice";
NSString * const SET_INTERROGATION_STATE = @"doctor/setStatus";
NSString * const FETCH_PROFESSIONAL_TITLES = @"doctor/professionalTitles";
NSString * const UPLOAD_IMAGE = @"doctor/imageUpload";
NSString * const SUBMIT_INFORMATIONS = @"doctor/auth";
NSString * const FETCH_INFORMATIONS = @"doctor/authInfo";
NSString * const BANK_LIST = @"doctor/getBanks";
NSString * const ADD_BANKCARD = @"doctor/bankCard/save";
NSString * const MY_BANKCARD = @"doctor/bankCard/get";

NSString * const FETCH_USERS_NAME = @"doctor/getUserIDAndName";
NSString * const SEND_PRESCRIPTION = @"doctor/prescription/add";
NSString * const FETCH_MY_PATIENTS = @"doctor/myPatients";
NSString * const PATIENT_INFORMATIONS = @"doctor/patient/info";
NSString * const HISTORICAL_PRESCROPTIONS = @"doctor/historicalPrescriptions";
NSString * const VIDEOCALL_STATUS = @"doctor/videoCallStatus";
NSString * const RESET_VIDEOCALL_STATUS = @"doctor/resetVideoCallStatus";
NSString * const SEND_CONSULTATION_CHARGE = @"doctor/consultationCharge";
NSString * const CONSULTATION_CHARGE_DETAIL = @"doctor/consultationDetail";

NSString * const PRESCRIPTION_DETAIL = @"doctor/prescription/info";
