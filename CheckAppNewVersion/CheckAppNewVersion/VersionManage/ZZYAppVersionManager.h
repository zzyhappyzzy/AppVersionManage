//
//  ZZYAppVersionManager.h
//  ZZYAppleLinkDemo
//
//  Created by zhenzhaoyang on 2017/8/1.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

/* mt (media type)
 1 – Music
 2 – Podcasts
 3 –  Audiobooks
 4 – TV Shows
 5 – Music Videos
 6 –  Movies
 7 – iPod Games
 8 – Mobile Software Applications / loads in the App Store on iOS
 9 – Ringtones
 10 – iTunes U
 11 – E-Books / loads in the iBookstore on iOS
 12 – Desktop Apps / loads in the Mac App Store in OS X
*/

/* ls
 ls = 1 是否打开itunes
 */

/*
Name	Country Code	Storefront ID
Algeria	DZ	143563
Angola	AO	143564
Anguilla	AI	143538
Antigua & Barbuda	AG	143540
Argentina	AR	143505
Armenia	AM	143524
Australia	AU	143460
Austria	AT	143445
Azerbaijan	AZ	143568
Bahrain	BH	143559
Bangladesh	BD	143490
Barbados	BB	143541
Belarus	BY	143565
Belgium	BE	143446
Belize	BZ	143555
Bermuda	BM	143542
Bolivia	BO	143556
Botswana	BW	143525
Brazil	BR	143503
British Virgin Islands	VG	143543
Brunei	BN	143560
Bulgaria	BG	143526
Canada	CA	143455
Cayman Islands	KY	143544
Chile	CL	143483
China	CN	143465
Colombia	CO	143501
Costa Rica	CR	143495
Cote D’Ivoire	CI	143527
Croatia	HR	143494
Cyprus	CY	143557
Czech Republic	CZ	143489
Denmark	DK	143458
Dominica	DM	143545
Dominican Rep.	DO	143508
Ecuador	EC	143509
Egypt	EG	143516
El Salvador	SV	143506
Estonia	EE	143518
Finland	FI	143447
France	FR	143442
Germany	DE	143443
Ghana	GH	143573
Greece	GR	143448
Grenada	GD	143546
Guatemala	GT	143504
Guyana	GY	143553
Honduras	HN	143510
Hong Kong	HK	143463
Hungary	HU	143482
Iceland	IS	143558
India	IN	143467
Indonesia	ID	143476
Ireland	IE	143449
Israel	IL	143491
Italy	IT	143450
Jamaica	JM	143511
Japan	JP	143462
Jordan	JO	143528
Kazakstan	KZ	143517
Kenya	KE	143529
Korea, Republic Of	KR	143466
Kuwait	KW	143493
Latvia	LV	143519
Lebanon	LB	143497
Liechtenstein	LI	143522
Lithuania	LT	143520
Luxembourg	LU	143451
Macau	MO	143515
Macedonia	MK	143530
Madagascar	MG	143531
Malaysia	MY	143473
Maldives	MV	143488
Mali	ML	143532
Malta	MT	143521
Mauritius	MU	143533
Mexico	MX	143468
Moldova, Republic Of	MD	143523
Montserrat	MS	143547
Nepal	NP	143484
Netherlands	NL	143452
New Zealand	NZ	143461
Nicaragua	NI	143512
Niger	NE	143534
Nigeria	NG	143561
Norway	NO	143457
Oman	OM	143562
Pakistan	PK	143477
Panama	PA	143485
Paraguay	PY	143513
Peru	PE	143507
Philippines	PH	143474
Poland	PL	143478
Portugal	PT	143453
Qatar	QA	143498
Romania	RO	143487
Russia	RU	143469
Saudi Arabia	SA	143479
Senegal	SN	143535
Serbia	RS	143500
Singapore	SG	143464
Slovakia	SK	143496
Slovenia	SI	143499
South Africa	ZA	143472
Spain	ES	143454
Sri Lanka	LK	143486
St. Kitts & Nevis	KN	143548
St. Lucia	LC	143549
St. Vincent & The Grenadines	VC	143550
Suriname	SR	143554
Sweden	SE	143456
Switzerland	CH	143459
Taiwan	TW	143470
Tanzania	TZ	143572
Thailand	TH	143475
The Bahamas	BS	143539
Trinidad & Tobago	TT	143551
Tunisia	TN	143536
Turkey	TR	143480
Turks & Caicos	TC	143552
Uganda	UG	143537
UK	GB	143444
Ukraine	UA	143492
United Arab Emirates	AE	143481
Uruguay	UY	143514
USA	US	143441
Uzbekistan	UZ	143566
Venezuela	VE	143502
Vietnam	VN	143471
Yemen	YE	143571
*/

#import <Foundation/Foundation.h>

typedef void(^NewVersionHandle)(NSString *releaseNote);

@interface ZZYAppVersionManager : NSObject

/**
   app在appstore的唯一id
 */
@property (nonatomic, copy) NSString *appstoreId;

/**
 国家代码 Country Code
 */
@property (nonatomic, copy) NSString *appstoreCountry;

/**
 有新版本的回调
 */
@property (nonatomic, copy) NewVersionHandle versionHandle;

/**
 距离上次弹框提示的最小时间（单位：秒）
 */
@property (nonatomic, assign) unsigned int minimalInterval;

+ (instancetype)sharedInstance;

- (void)start;

/**
 appstore页面
 */
- (void)openAppInAppstore;

/**
 appstore的评价页
 */
- (void)openAppInAppstoreWithReviewPage;

@end
