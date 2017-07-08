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
    XJSortTypesAscending
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
typedef NS_ENUM(NSInteger, XJAuthenticationStatus) {
    XJAuthenticationStatusNot = 1,  //未认证
    XJAuthenticationStatusWait = 2, //待认证
    XJAuthenticationStatusFail = 3, //认证失败
    XJAuthenticationStatusSuccess = 4, //正常
    XJAuthenticationStatusStop = 9  //停诊
};
typedef NS_ENUM(NSInteger, XJAdviceType) {
    XJAdviceTypeAll = 0,
    XJAdviceTypeDisease,
    XJAdviceTypeTherapy
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
extern NSString * const USERAVATARDATA;
extern NSString * const USERAVATARSTRING;
extern NSString * const KEYCHAINSERVICE;
extern NSString * const FIRSTLOAD;
extern NSString * const LAST_RUN_VERSION;

//常用数值
extern CGFloat const TABBARHEIGHT;
extern CGFloat const NAVIGATIONBARHEIGHT;

//内容
extern NSString * const XJSearchPlaceholder;
extern NSString * const XJAllDiseases;
extern NSString * const XJAllContents;
extern NSString * const XJAllTherapies;
extern NSString * const XJVideoCanNotPlay;
extern NSString * const XJNetworkError;

//问诊
extern NSString * const XJCommonTip;
extern NSString * const XJCommonCancel;
extern NSString * const XJCommonEnsure;
extern NSString * const XJIsMakePhoneCall;
extern NSString * const XJPleaseInputPrescriptionWords;
extern NSString * const XJIsFree;

//个人中心
extern NSString * const XJMyInterrogation;
extern NSString * const XJMyWallet;
extern NSString * const XJMyDoctors;
extern NSString * const XJMyCollections;
extern NSString * const XJMyPatients;
extern NSString * const XJMyScores;
extern NSString * const XJMyBandCard;
extern NSString * const XJInviteDoctors;
extern NSString * const XJInvitePatients;
extern NSString * const XJMyAccount;
extern NSString * const XJHelpAndFeedback;
extern NSString * const XJPersonalSetting;
extern NSString * const XJInterrogationSetting;
extern NSString * const XJTelephoneNumber;
extern NSString * const XJChangePassword;
extern NSString * const XJCheckNewVersion;
extern NSString * const XJServiceAgreement;
extern NSString * const XJClearCache;
extern NSString * const XJAboutUs;
extern NSString * const XJMySpecialits;
extern NSString * const XJMyCity;
extern NSString * const XJStopInterrogationTip;

//登录注册
extern NSString * const XJInputPhoneNumber;
extern NSString * const XJInputPassword;
extern NSString * const XJInputVerificationCode;
extern NSString * const XJInputPasswordAgain;
extern NSString * const XJUserAgreement;
extern NSString * const XJFetchVerificationCode;
extern NSString * const XJInputCorrectPhoneNumberTip;
extern NSString * const XJInputPasswordTip;
extern NSString * const XJPasswordFormatTip;
extern NSString * const XJDifferentPasswordTip;
extern NSString * const XJInputVerificationCodeTip;
extern NSString * const XJPleaseEnsureInformation;
extern NSString * const XJNameTitle;
extern NSString * const XJIDCardTitle;
extern NSString * const XJPleaseInputRealname;
extern NSString * const XJPleaseInputIDCardNumber;
extern NSString * const XJCameraNotAvailable;
extern NSString * const XJAppCameraAccessNotAuthorized;
extern NSString * const XJAppPhotoLibraryAccessNotAuthorized;
extern NSString * const XJPleaseUploadAuthenticationPicture;
extern NSString * const XJPleaseInputCorrectIDCardNumber;
extern NSString * const XJKeepWaiting;
extern NSString * const XJAuthenticationFail;
extern NSString * const XJAuthenticationFailed;
extern NSString * const XJWaitingForAuthentication;
extern NSString * const XJFindPassword;

//NotificationName
extern NSString * const XJLoginSuccess;
extern NSString * const XJApplicationBecomeActive;
extern NSString * const XJSetupUnreadMessagesCount;
extern NSString * const XJConversationsDidChange;

//接口
//1.BaseURL
extern NSString * const BASEAPIURL;
extern NSString * const ADVICEBASEURL;


//2.用户相关
extern NSString * const USER_LOGIN;
extern NSString * const USER_REGISTER;
extern NSString * const USER_AUTHENTICATION;
extern NSString * const UPLOAD_AUTHENTICATION_IMAGE;
extern NSString * const UPLOAD_TITLES_IMAGE;
extern NSString * const FETCH_VERIFICATION_CODE;
extern NSString * const FIND_PASSWORD;
extern NSString * const USER_LOGOUT;
extern NSString * const FETCH_BASIC_INFORMATIONS;
extern NSString * const CHANGE_PASSWORD;

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
extern NSString * const FETCH_PROFESSIONAL_TITLES;
extern NSString * const UPLOAD_IMAGE;
extern NSString * const SUBMIT_INFORMATIONS;
extern NSString * const FETCH_INFORMATIONS;
extern NSString * const BANK_LIST;
extern NSString * const ADD_BANKCARD;
extern NSString * const MY_BANKCARD;

//5.消息(问诊)
extern NSString * const FETCH_USERS_NAME;
extern NSString * const SEND_PRESCRIPTION;
extern NSString * const FETCH_MY_PATIENTS;
extern NSString * const PATIENT_INFORMATIONS;
extern NSString * const HISTORICAL_PRESCROPTIONS;
extern NSString * const VIDEOCALL_STATUS;
extern NSString * const RESET_VIDEOCALL_STATUS;
extern NSString * const SEND_CONSULTATION_CHARGE;
extern NSString * const CONSULTATION_CHARGE_DETAIL;

//6.处方
extern NSString * const PRESCRIPTION_DETAIL;







