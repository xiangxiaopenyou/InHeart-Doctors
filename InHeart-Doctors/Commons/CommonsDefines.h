//
//  CommonsDefines.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XJContentsTypes) {
    XJContentsTypesNone,
    XJContentsTypesDiseases,
    XJContentsTypesContents,
    XJContentsTypesTherapies
};
typedef NS_ENUM(NSInteger, XJSortTypes) {
    XJSortTypesNone,
    XJSortTypesDescending,
    XJSortTypesIncrease
};
typedef NS_ENUM(NSInteger, XJNewsTypes) {
    XJNewsTypesIndustry,
    XJNewsTypesCollege,
    XJNewsTypesSystem
    
};
typedef NS_ENUM(NSInteger, XJUserSex) {
    XJUserSexMale = 1,
    XJUserSexFemale = 2
};
//key & secret
extern NSString * const EMChatKey;
extern NSString * const APNSCertName;

//用户相关
extern NSString * const USERID;
extern NSString * const USERTOKEN;
extern NSString * const USERCODE;
extern NSString * const USERREALNAME;
extern NSString * const USERNAME;
extern NSString * const USERENCRYPTEDPASSWORD;
extern NSString * const KEYCHAINSERVICE;
extern NSString * const FIRSTLOAD;
extern NSString * const LAST_RUN_VERSION;

//常用数值
extern CGFloat const TABBARHEIGHT;
extern CGFloat const NAVIGATIONBARHEIGHT;

//内容
extern NSString * const kSearchPlaceholder;
extern NSString * const kAllDiseases;
extern NSString * const kAllContents;
extern NSString * const kAllTherapies;
extern NSString * const kVideoCanNotPlay;
extern NSString * const kNetworkError;

//问诊
extern NSString * const kCommonTip;
extern NSString * const kCommonCancel;
extern NSString * const kCommonEnsure;
extern NSString * const kIsMakePhoneCall;
extern NSString * const kPleaseInputPrescriptionWords;
extern NSString * const kIsFree;

//个人中心
extern NSString * const kMyInterrogation;
extern NSString * const kMyWallet;
extern NSString * const kMyDoctors;
extern NSString * const kMyCollections;
extern NSString * const kMyPatients;
extern NSString * const kMyBandCard;
extern NSString * const kInviteDoctors;
extern NSString * const kMyAccount;
extern NSString * const kHelpAndFeedback;
extern NSString * const kPersonalSetting;
extern NSString * const kInterrogationSetting;
extern NSString * const kTelephoneNumber;
extern NSString * const kChangePassword;
extern NSString * const kCheckNewVersion;
extern NSString * const kServiceAgreement;
extern NSString * const kClearCache;
extern NSString * const kAboutUs;
extern NSString * const kMySpecialits;
extern NSString * const kMyCity;
extern NSString * const kStopInterrogationTip;

//登录注册
extern NSString * const kInputPhoneNumber;
extern NSString * const kInputPassword;
extern NSString * const kInputVerificationCode;
extern NSString * const kInputPasswordAgain;
extern NSString * const kUserAgreement;
extern NSString * const kFetchVerificationCode;
extern NSString * const kInputCorrectPhoneNumberTip;
extern NSString * const kInputPasswordTip;
extern NSString * const kPasswordFormatTip;
extern NSString * const kDifferentPasswordTip;
extern NSString * const kInputVerificationCodeTip;
extern NSString * const kPleaseEnsureInformation;
extern NSString * const kNameTitle;
extern NSString * const kIDCardTitle;
extern NSString * const kPleaseInputRealname;
extern NSString * const kPleaseInputIDCardNumber;
extern NSString * const kCameraNotAvailable;
extern NSString * const kAppCameraAccessNotAuthorized;
extern NSString * const kAppPhotoLibraryAccessNotAuthorized;
extern NSString * const kPleaseUploadAuthenticationPicture;
extern NSString * const kPleaseInputCorrectIDCardNumber;
extern NSString * const kKeepWaiting;
extern NSString * const kAuthenticationFail;
extern NSString * const kAuthenticationFailed;
extern NSString * const kWaitingForAuthentication;
extern NSString * const kFindPassword;

//NotificationName
extern NSString * const kLoginSuccess;
extern NSString * const kApplicationBecomeActive;
extern NSString * const kSetupUnreadMessagesCount;
extern NSString * const kConversationsDidChange;

//接口
//1.BaseURL
extern NSString * const BASEAPIURL;


//2.用户相关
extern NSString * const USER_LOGIN;
extern NSString * const USER_REGISTER;
extern NSString * const USER_AUTHENTICATION;
extern NSString * const UPLOAD_AUTHENTICATION_IMAGE;
extern NSString * const UPLOAD_TITLES_IMAGE;
extern NSString * const FETCH_VERIFICATION_CODE;
extern NSString * const FIND_PASSWORD;
extern NSString * const USER_LOGOUT;

//3.内容
extern NSString * const FETCH_CONTENTS_LIST;
extern NSString * const FETCH_CONTENTS_TYPES;
extern NSString * const FETCH_DISEASES;
extern NSString * const FETCH_THERAPIES;
extern NSString * const FETCH_CONTENT_DETAIL;
extern NSString * const COLLECT_CONTENT;
extern NSString * const CANCEL_COLLECT_CONTENT;

//4.个人中心
extern NSString * const FETCH_COLLECTIONS_LIST;
extern NSString * const FETCH_PERSONAL_INFORMATION;
extern NSString * const FETCH_ACCOUNT_BALANCE;
extern NSString * const FETCH_BILL_LIST;
extern NSString * const FETCH_CITIES_LIST;
extern NSString * const EDIT_INFORMATION;
extern NSString * const UPLOAD_AVATAR;
extern NSString * const FETCH_BILLS_LIST;
extern NSString * const FETCH_COMMON_PRICE;
extern NSString * const SET_COMMON_PRICE;
extern NSString * const SET_INTERROGATION_STATE;

//5.消息(问诊)
extern NSString * const FETCH_USERS_NAME;
extern NSString * const SEND_PRESCRIPTION;







