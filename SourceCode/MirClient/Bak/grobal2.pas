unit Grobal2;

interface
uses
   Math,windows;
Const
  BUFFERSIZE    =1024;
//�汾��
//  VERSION_NUMBER_0522 = 20010522;
  VERSION_NUMBER_0522 = 20020522;
  CLIENT_VERSION_NUMBER = 120040918;
  CM_POWERBLOCK = 0;
  //�ͻ��˷��͵�����
  CM_SOFTCLOSE  =0;

  CM_QUERYUSERSTATE = 2;
  CM_ADJUST_BONUS =60;

  CM_QUERYUSERNAME = 80; //��ѯ�û�����
  CM_QUERYBAGITEMS = 81; //��ѯ��������

  CM_QUERYCHR     = 100; //��ѯ����
  CM_NEWCHR       = 101; //������
  CM_DELCHR       = 102; //ɾ������
  CM_SELCHR       = 103; //ѡ������
  CM_SELECTSERVER = 104; //ѡ�������
///////////
  //����
  CM_DROPITEM = 1000; //������Ʒ
  CM_PICKUP = 1001; //����
  CM_OPENDOOR = 1002; //����
  CM_TAKEONITEM = 1003; //����/����/���� ��Ʒ
  CM_TAKEOFFITEM = 1004; //������Ʒ
  CM_EAT = 1006; //����Ʒ
  CM_BUTCH = 1007; //
  CM_MAGICKEYCHANGE = 1008; //�ı�ħ������

  CM_CLICKNPC = 1010; //���NPC???
  CM_MERCHANTDLGSELECT = 1011; // NPC Tag Click ѡ�����˹��ܴ���
  CM_MERCHANTQUERYSELLPRICE = 1012; //��ѯ���������˵ļ۸�
  CM_USERSELLITEM = 1013; //ѡ����Ʒ
  CM_USERBUYITEM = 1014; //������Ʒ
  CM_USERGETDETAILITEM = 1015; //????????????????????????
  CM_DROPGOLD = 1016; //�������

  CM_LOGINNOTICEOK = 1018; //������Ϸ����ȷ����ť
  //�������
  CM_GROUPMODE = 1019; //����ģʽ
  CM_CREATEGROUP = 1020; //��������
  CM_ADDGROUPMEMBER = 1021; //��ӱ����Ա
  CM_DELGROUPMEMBER = 1022; //ɾ�������Ա
  //����
  CM_USERREPAIRITEM = 1023; //������Ʒ
  CM_MERCHANTQUERYREPAIRCOST = 1024; //��ѯ����۸�

    //�������
  CM_DEALTRY = 1025; //���׿�ʼ//////////////
  CM_DEALADDITEM = 1026;//���������Ʒ////////////
  CM_DEALDELITEM = 1027; //����ɾ����Ʒ////////////
  CM_DEALCANCEL = 1028; //����ȡ��/////////////
  CM_DEALCHGGOLD = 1029;//���׸ı���////////////
  CM_DEALEND = 1030;//�������//////////////
  CM_USERSTORAGEITEM = 1031; //�û��洢��Ʒ
  CM_USERTAKEBACKSTORAGEITEM = 1032; //�Ӳֿ�ȡ����Ʒ
  CM_WANTMINIMAP = 1033;
  CM_USERMAKEDRUGITEM = 1034; //������ҩ��Ʒ
  //�л����
  CM_OPENGUILDDLG = 1035; //���лᴰ��
  CM_GUILDHOME = 1036; //�л���ҳ
  CM_GUILDMEMBERLIST = 1037; //�л��Ա�б�
  CM_GUILDADDMEMBER = 1038; //����л��Ա
  CM_GUILDDELMEMBER = 1039; //ɾ���л��Ա
  CM_GUILDUPDATENOTICE = 1040; //�����л���Ϣ
  CM_GUILDUPDATERANKINFO = 1041; //�����л�ȼ�/������Ϣ????

  CM_SPEEDHACKUSER = 1043;
  CM_GUILDMAKEALLY = 1044; //�л����
  CM_GUILDBREAKALLY = 1045; //�л����
///////////////
  //��¼�йص�����
  CM_PROTOCOL       = 2000;
  CM_IDPASSWORD     = 2001; //�����û���/����
  CM_PASSWORD     = 2001;
  CM_ADDNEWUSER     = 2002;
  CM_CHANGEPASSWORD = 2003; //��������
  CM_UPDATEUSER     = 2004;

/////////////////////

///����...
  CM_THROW    = 3005;  //Ͷ��
  CM_RUSHKUNG = 3007; //
//.......end..
  CM_RUSH     = 3006; //
  CM_FIREHIT  = 3008; //�һ�
  CM_BACKSTEP = 3009; //��·���ɹ�????
  CM_TURN     = 3010; //ת
  CM_WALK     = 3011; //��·
  CM_SITDOWN  = 3012; //��
  CM_RUN      = 3013; //��
  CM_HIT      = 3014; //��
  CM_HEAVYHIT = 3015;
  CM_BIGHIT   = 3016;
  CM_SPELL    = 3017; //ħ��
  CM_POWERHIT = 3018; //��ɱ
  CM_LONGHIT  = 3019; //��ɱ
  CM_DIGUP    = 3020; //��ȡ
  CM_DIGDOWN  = 3021; //����?????????
  CM_FLYAXE   = 3022; //???????????????
  CM_LIGHTING = 3023; //����?????????????
  CM_WIDEHIT  = 3024; //����


  CM_SAY = 3030; //˵��
  CM_RIDE = 3031; //���???
  CM_HORSERUN     = 3035;
  CM_CRSHIT       = 3036;
  CM_3037         = 3037;
  CM_TWINHIT      = 3038;
  RCC_USERHUMAN    = 0;
//////////
  //װ����Ŀ
  U_DRESS       =0;    //�·�
  U_WEAPON      =1;    //����
  U_RIGHTHAND   =2;    //����
  U_NECKLACE    =3;    //����
  U_HELMET      =4;    //ͷ��
  U_ARMRINGL    =5;    //���ֽ�ָ
  U_ARMRINGR    =6;    //���ֽ�ָ
  U_RINGL       =7;    //���ָ
  U_RINGR       =8;    //�ҽ�ָ
  U_BUJUK       = 9;
  U_BELT        = 10;
  U_BOOTS       = 11;
  U_CHARM       = 12;

////////����Ϊ����������..
/////////////////////////////////////////////////

///////////////////////////////


  //�������˷��͵�����
   {+//****************************************** }
  { #1. Server To Client Message                 }
  {=******************************************** }
////////////////////
////////////////////////
//����..start
  SM_SPACEMOVE_HIDE =1041;
  SM_SPACEMOVE_HIDE2=1042;
  SM_SPACEMOVE_SHOW =1043;
  SM_SPACEMOVE_SHOW2=1044;
  SM_MOVEFAIL       =1045;
  SM_BUTCH          =1046;

  SM_MAGICFIRE      =1072;
  SM_MAGICFIRE_FAIL = 1073;

  SM_THROW =5;
  SM_RUSHKUNG = 7; //
//.....end


  SM_RUSH = 6; //
  SM_FIREHIT = 8; //�һ�
  SM_BACKSTEP = 9; //��·���ɹ�????
  SM_TURN = 10; //ת������
  SM_WALK = 11; //��·
  SM_SITDOWN = 12; //��
  SM_RUN = 13; //��
  SM_HIT = 14; //����
  SM_HEAVYHIT = 15;
  SM_BIGHIT =16;
  SM_SPELL = 17; //ʹ��ħ��
  SM_POWERHIT = 18; //��ɱ
  SM_LONGHIT = 19; //��ɱ
  SM_DIGUP = 20; //��ȡ
  SM_DIGDOWN = 21; //����?????????
  SM_FLYAXE = 22; //???????????????
  SM_LIGHTING = 23; //����?????????????
  SM_WIDEHIT = 24; //����
  SM_CRSHIT             = 25;
  SM_TWINHIT            = 26;

  SM_DISAPPEAR = 30; //��Ʒ��ʧ??????
  SM_STRUCK = 31; //
  SM_DEATH = 32; //
  SM_SKELETON = 33; // SM_DEATH ʬ��??ʬ��
  SM_NOWDEATH = 34; //
  SM_41                 = 36;
  SM_HEAR = 40; //����˵��
  SM_FEATURECHANGED = 41; //��ò??����??�ı�???????????
  SM_USERNAME = 42; //�û���??�����???????
  SM_WINEXP = 44; //ʤ��ָ��???ɱ�ֻ�õľ���ֵ???????????????
  SM_LEVELUP = 45; //�ȼ�����
  SM_DAYCHANGING = 46; //�������ڸı�????
  SM_LOGON = 50; //��¼ע��
  SM_NEWMAP = 51; //�µ�ͼ
  SM_ABILITY = 52; //����
  SM_HEALTHSPELLCHANGED = 53; //��Ѫ��Ѫ �ı�
  SM_MAPDESCRIPTION = 54;//��ͼ����,��ͼ����
 /////////////

  SM_SYSMESSAGE = 100; //ϵͳ��Ϣ
  SM_GROUPMESSAGE = 101; //�����Ϣ
  SM_CRY = 102; //��
  SM_WHISPER = 103; //˽��
  SM_GUILDMESSAGE = 104; //�л���Ϣ

  SM_ADDITEM = 200; //�����Ʒ
//  SM_ADDITEM = 165; //�����Ʒ
  SM_BAGITEMS = 201; //������Ʒ
//  SM_BAGITEMS = 166; //������Ʒ
  SM_DELITEM = 202; //ɾ����Ʒ????
//  SM_DELITEM = 167; //ɾ����Ʒ????

  SM_UPDATEITEM	= 203;
  SM_ADDMAGIC 	= 210; //���ħ��
  SM_SENDMYMAGIC= 211; //�������ħ��
  SM_DELMAGIC	= 212;

  //��¼�����ʺš��½�ɫ����ѯ��ɫ��
  SM_VERSION_AVAILABLE = 500; //
  SM_CERTIFICATION_FAIL = 501; //
  SM_ID_NOTFOUND = 502; //IDδ����,�û�������
  SM_PASSWD_FAIL = 503; //�������
  SM_NEWID_SUCCESS = 504; //������ID�ɹ�
  SM_NEWID_FAIL = 505; //��IDʧ��
  SM_CHGPASSWD_SUCCESS = 506; //��������ɹ�
  SM_CHGPASSWD_FAIL = 507; //��������ʧ��

  SM_QUERYCHR = 520; //��ѯ����(2�˴���)
  SM_NEWCHR_SUCCESS = 521; //��������ɹ�
  SM_NEWCHR_FAIL = 522; //��������ʧ��
  SM_DELCHR_SUCCESS = 523; //ɾ������ɹ�
  SM_DELCHR_FAIL = 524; //ɾ������ʧ��
  SM_STARTPLAY = 525; //��ʼ��Ϸ
  SM_STARTFAIL = 526; //������Ϸʧ��
  SM_QUERYCHR_FAIL = 527; //��ѯ����ʧ��
  SM_OUTOFCONNECTION   = 528; //�����ѶϿ�
  SM_PASSOK_SELECTSERVER = 529; //�û���/���� ��֤ͨ��
  SM_SELECTSERVER_OK = 530; //������ѡ��ɹ�
  SM_NEEDUPDATE_ACCOUNT = 531; //��Ҫ����_˵��????
  SM_UPDATEID_SUCCESS = 532; //����ID�ɹ�?????
  SM_UPDATEID_FAIL = 533; //����IDʧ��???????
/////////////

  SM_DROPITEM_SUCCESS = 600; //������Ʒ�ɹ�
  SM_DROPITEM_FAIL = 601; //������Ʒʧ��
  SM_ITEMSHOW = 610; //��ʾ��Ʒ
  SM_ITEMHIDE = 611; //���ϵ���Ʒ��ʧ
  SM_OPENDOOR_OK = 612; //���ųɹ�
  SM_OPENDOOR_LOCK = 613; //
  SM_CLOSEDOOR = 614; //
  SM_TAKEON_OK = 615; //���ϴ��ϳɹ�
  SM_TAKEON_FAIL = 616; //��ʧ��

  SM_TAKEOFF_OK = 619; //���³ɹ�
  SM_TAKEOFF_FAIL = 620; //����ʧ��
  SM_SENDUSEITEMS = 621; //���ϴ�����Ʒ
  SM_WEIGHTCHANGED = 622; //���������ı�

  SM_CLEAROBJECTS = 633; //�������??????????
  SM_CHANGEMAP = 634; //��ͼ�ı�
  SM_EAT_OK = 635; //����Ʒ�ɹ�
  SM_EAT_FAIL = 636; //����Ʒʧ��
//  SM_BUTCH = 637; //
//  SM_MAGICFIRE = 638; //ħ����?????????????
//  SM_MAGICFIRE_FAIL = 639; //ħ����ʧ��?????????????
  SM_MAGIC_LVEXP = 640; //ħ���ȼ�
  SM_DURACHANGE = 642;
  SM_MERCHANTSAY = 643; //����˵��
  SM_MERCHANTDLGCLOSE = 644; //���˴��ڹر�
  SM_SENDGOODSLIST = 645; //�����б�
  SM_SENDUSERSELL = 646; //�û�����
  SM_SENDBUYPRICE = 647; //����۸�
  SM_USERSELLITEM_OK = 648; //�û�������Ʒ�ɹ�
  SM_USERSELLITEM_FAIL = 649; //�û�������Ʒʧ��
  SM_BUYITEM_SUCCESS = 650; //�û�������Ʒ�ɹ�
  SM_BUYITEM_FAIL = 651; //�û�����ʧ��
  SM_SENDDETAILGOODSLIST = 652; //��ϸ�����б�
  SM_GOLDCHANGED = 653; //��Ҹı�
  SM_CHANGELIGHT = 654; //�ı�����????
  SM_CHANGENAMECOLOR = 656; //�ı䱦����ɫ?????
  SM_CHARSTATUSCHANGED = 657;
  SM_SENDNOTICE = 658; //������Ϸ��������
  SM_CREATEGROUP_OK = 660; //��������ɹ�
  SM_CREATEGROUP_FAIL = 661; //��������ʧ��
  SM_GROUPCANCEL = 666; //����ȡ��??????????
  SM_GROUPMEMBERS = 667; //�����Ա
 /////////////
  SM_SENDUSERREPAIR=668;//2076;

  SM_DEALREMOTEADDITEM = 682;//2115;  
  SM_DEALREMOTEDELITEM = 683;//2116;  
  
  SM_SENDUSERSTORAGEITEM=700;//2121;  
  SM_SAVEITEMLIST = 704;//2086;
    
  SM_AREASTATE = 708; //����״̬
//  SM_DELITEMS = 203; //ɾ����Ʒ??????
  SM_DELITEMS = 709; //ɾ����Ʒ??????

  SM_READMINIMAP_OK=710;//2122;
  SM_READMINIMAP_FAIL=711;//2123;
  SM_SENDUSERMAKEDRUGITEMLIST=712;
  SM_716                = 716;

  SM_CHANGEGUILDNAME = 750; //�ı��л�����
  SM_SENDUSERSTATE=751;
  SM_SUBABILITY = 752;
  SM_OPENGUILDDLG = 753; //���лᴰ��
  SM_OPENGUILDDLG_FAIL = 754; //���лᴰ��ʧ��
  SM_SENDGUILDHOME = 755; //�л���ҳ
  SM_SENDGUILDMEMBERLIST = 756; //�л��Ա�б�
  SM_GUILDADDMEMBER_OK = 757; //�л���ӳ�Ա�ɹ�
  SM_GUILDADDMEMBER_FAIL = 758; //�л���ӳ�Աʧ��
  SM_GUILDDELMEMBER_OK = 759; //�л�ɾ����Ա�ɹ�
  SM_GUILDDELMEMBER_FAIL = 760; //�л�ɾ����Աʧ��
  SM_GUILDRANKUPDATE_FAIL = 761; //�л�ȼ�/���и���ʧ��
  SM_BUILDGUILD_OK = 762; //�����л�ɹ�
  SM_BUILDGUILD_FAIL = 763; //�����л�ʧ��
  
  SM_MYSTATUS = 766;//131;
  
  SM_GUILDMAKEALLY_OK = 768; //�����л�ͬ�˳ɹ�
  SM_GUILDMAKEALLY_FAIL = 769; //�����л�ͬ��ʧ��
  SM_GUILDBREAKALLY_OK = 770; //ɾ���л�ͬ�˳ɹ�
  SM_GUILDBREAKALLY_FAIL = 771; //ɾ���л�ͬ��ʧ��
  SM_DLGMSG = 772; //������Ϣ????��������???????
/////////////

  SM_RECONNECT =802;
  
  SM_SHOWEVENT = 804; //��ʾ�¼�????????
  SM_HIDEEVENT = 805; //�����¼�?????????
  
  SM_TIMECHECK_MSG = 810;
  SM_ADJUST_BONUS = 811;

  SM_OPENHEALTH = 1100; //�򿪽���????????
  SM_CLOSEHEALTH = 1101; //�رս���???????
  SM_CHANGEFACE = 1104; //
  SM_RIDEHORSE = 1300; //����
  SM_MONSTERSAY = 1501; //����˵��
  SM_SERVERCONFIG = 5007;
  SM_GAMEGOLDNAME = 5008;
  SM_PASSWORD     = 5009;
  SM_HORSERUN     = 5010; 

 ////////////////////////
////////////////////////////
//����δ����..


  SM_VERSION_FAIL =121;




  SM_LAMPCHANGEDURA=241;

  SM_ALIVE =263;


  SM_INSTANCEHEALGUAGE=314;
  SM_BREAKWEAPON=315;

  //�Ի���Ϣ
//  SM_SPACEMOVE_HIDE =1041;
//  SM_SPACEMOVE_HIDE2=1042;
//  SM_SPACEMOVE_SHOW =1043;
//  SM_SPACEMOVE_SHOW2=1044;
//  SM_MOVEFAIL       =1045;


  SM_HIDE =1224;
  SM_GHOST=1225;


  SM_EXCHGTAKEON_OK=2056;
  SM_EXCHGTAKEON_FAIL=2057;




  SM_SENDREPAIRCOST=2080;
  SM_USERREPAIRITEM_OK=2081;
  SM_USERREPAIRITEM_FAIL=2082;
  SM_STORAGE_OK=2083;
  SM_STORAGE_FULL=2084;
  SM_STORAGE_FAIL=2085;


  SM_TAKEBACKSTORAGEITEM_OK=2087;
  SM_TAKEBACKSTORAGEITEM_FAIL=2088;
  SM_TAKEBACKSTORAGEITEM_FULLBAG=2089;

  SM_MAKEDRUG_SUCCESS=2092;
  SM_MAKEDRUG_FAIL=2093;

  SM_TEST=2095;
  SM_GROUPMODECHANGED=2096;
  SM_GROUPADDMEM_OK=2099;
  SM_GROUPADDMEM_FAIL=2100;
  SM_GROUPDELMEM_OK=2101;
  SM_GROUPDELMEM_FAIL=2102;


  SM_DEALTRY_FAIL=2108;
  SM_DEALMENU=2109;
  SM_DEALCANCEL=2110;
  SM_DEALADDITEM_OK=2111;
  SM_DEALADDITEM_FAIL=2112;
  SM_DEALDELITEM_OK=2113;
  SM_DEALDELITEM_FAIL=2114;


  SM_DEALCHGGOLD_OK=2117;
  SM_DEALCHGGOLD_FAIL=2118;
  SM_DEALREMOTECHGGOLD=2119;
  SM_DEALSUCCESS=2120;




  SM_MENU_OK=2137;
  SM_DONATE_OK=2139;
  SM_DONATE_FAIL=2140;

  SM_ACTION_MIN=2200;
  SM_ACTION_MAX=2499;
  SM_ACTION2_MIN=2500;
  SM_ACTION2_MAX=2999;
//
  SM_PLAYDICE    = 8001;
  SM_PASSWORDSTATUS = 8002;
  SM_NEEDPASSWORD = 8003; 
  SM_GETREGINFO = 8004;

  RCC_MERCHANT  =1;
  RCC_GUARD     =2;



  DEFBLOCKSIZE =16;

  UNITX = 48;
  UNITY = 32;
  LOGICALMAPUNIT =20;
  HALFX = 24;
  HALFY = 16;

  ET_DIGOUTZOMBI =0;
  ET_PILESTONES = 1;
  ET_HOLYCURTAIN = 2;
  ET_FIRE= 3;
  ET_SCULPEICE = 4;

  STATE_STONE_MODE =0;
  STATE_OPENHEATH = 1;

  MAXBAGITEM = 52;

  DR_UP=0;
  DR_UPRIGHT =1;
  DR_RIGHT =2;
  DR_DOWNRIGHT =3;
  DR_DOWN =4;
  DR_DOWNLEFT =5;
  DR_LEFT =6;
  DR_UPLEFT =7;

type
  pTDefaultMessage=^TDefaultMessage;

{    //����ԭ���Ķ���:
  TDefaultMessage=packed record  //Size=12
    Ident :word;
    Recog :integer;  //ʶ����
    Param :smallint;
    Tag   :smallint;
    Series:smallint;
  end;
}
//�����µĶ���
  TDefaultMessage=packed record  //Size=12
    Recog :integer;  //ʶ����
    Ident :word;
    Param :smallint;
    Tag   :smallint;
    Series:smallint;
  end;


  //Ident=SM_DAYCHANGING
  //   Param=DayBright
  //   Tag=���Ũ�ȣ�0��1��2��3

  TUserInfo = packed Record
     Name:String[32];
     Looks:integer;
     StdMode:Integer;
     Shape:Integer;
  end;

 //Ӧ����44�ֽ�
 TSTDITEM = packed record
    Name         :String[14];
    StdMode      :Byte;
    Shape        :Byte;
    Weight       :Byte;
    AniCount     :Byte;
    Source       :Byte;
    Reserved     :Byte;
    NeedIdentify :Byte;
    Looks        :Word;
    DuraMax      :Word;
    AC           :Word;
    MAC          :Word;
    DC           :Word;
    MC           :Word;
    SC           :Word;
    Need         :Byte;
    NeedLevel    :Byte;
    Price        :UINT;
  end;


  TRegInfo = record
    sKey:String;
    sServerName:String;
    sRegSrvIP:String[15];
    nRegPort:Integer;
  end;

 PTClientItem=^TClientItem;
  TCLIENTITEM = packed record
    s: TSTDITEM;
    MakeIndex: Integer; //
    Dura: Word;         //�־�
    DuraMax: Word;      //���־�
  end;



  TAbility= packed record
     MP,MaxMP:Integer;
     HP,MaxHP:integer;
     Exp,MaxExp:Integer;
     Level:Integer;
     Weight,MaxWeight:Integer;
     WearWeight,MaxWearWeight:Integer;
     HandWeight,MaxHandWeight:Integer;
     AC:Integer;
     MAC:Integer;
     DC:Integer;
     MC,SC:Integer;
  end;

  PTChrMsg=^TChrMsg;

  TChrMsg= packed Record
     Ident:integer;
     Dir:Integer;
     X,Y:Integer;
     State:integer;
     feature:integer;
     saying:string;
     Sound:integer;
  end;

  TClientConf=record
     boClientCanSet    :boolean;
     boRunHuman        :boolean;
     boRunMon          :boolean;
     boRunNpc          :boolean;
     boWarRunAll       :boolean;
     btDieColor        :byte;
     wSpellTime        :word;
     wHitIime          :word;
     wItemFlashTime    :word;
     btItemSpeed       :byte;
     boCanStartRun     :boolean;
     boParalyCanRun    :boolean;
     boParalyCanWalk   :boolean;
     boParalyCanHit    :boolean;
     boParalyCanSpell  :boolean;
     boShowRedHPLable  :boolean;
     boShowHPNumber    :boolean;
     boShowJobLevel    :boolean;
     boDuraAlert       :boolean;
     boMagicLock       :boolean;
     boAutoPuckUpItem  :boolean;
  end;


  TUserStateInfo= packed Record
     UserName:String[32];
     GuildName:String[32];
     GuildRankName:String[32];
     NameColor:Integer;
     Feature:integer;
     UseItems:Array[0..127] of TClientItem;
  end;

  TUserCharacterInfo= packed Record
     Name:String;
     Job:byte;
     Hair:smallint;
     level:Integer;
     Sex:byte;
  end;

  TUserEntry =record
    sAccount      :String[10];
    sPassword     :String[10];
    sUserName     :String[20];
    sSSNo         :String[14];
    sPhone        :String[14];
    sQuiz         :String[20];
    sAnswer       :String[12];
    sEMail        :String[40];
  end;
  TUserEntryAdd =record
    sQuiz2        :String[20];
    sAnswer2      :String[12];
    sBirthDay     :String[10];
    sMobilePhone  :String[15];
    sMemo         :String[40];
    sMemo2        :String[40];
  end;

  PTDropItem=^TDropItem;
  TDropItem= packed record
     Id:Integer;
     X,Y:Integer;
     Looks:integer;
     FlashTime:LongInt;
     Name:String[16];
     BoFlash:Boolean;
     FlashStepTime:LongInt;
     FlashStep:Integer;
  end;

  PTClientMagic=^TClientMagic;
  TSTANDARDMAGIC = packed record   //ħ��
    wMagicID: Word;          //���
    Num:byte;          //����ӦΪMagicName:Array[0..13] of char //num �����Լ��ӵ�,��ʾ�������ֵ���Ч�ַ���.
    sMagicName: Array[0..12] of Char;   //���� 12
    btEffectType: BYTE;
    btEffect: BYTE;    //Ч��
    wSpell: Word;     //ħ��
    wPower: Word;  //
    TrainLevel: Array[0..3] of BYTE;     //������Ҫ�ĵȼ�
    MaxTrain: Array[0..3] of Integer; //����
    btTrainLv:Byte;          //�������ȼ�
    btJob: BYTE;
    dwDelayTime: Integer;   //�ӳ�ʱ��
    btDefSpell: BYTE;       //Ĭ��
    btDefMinPower: BYTE;
    wMaxPower: Word;
    btDefMaxPower: BYTE;
    szDesc: Array[0..15] of Char;
  end;

  TCLIENTMAGIC = packed record    //ħ��
    Key: Char;          //����
    level:byte;            //�ȼ�
    CurTrain:integer;     //��ǰ����
    Def: TSTANDARDMAGIC;
  end;



  TNakedAbility=packed Record
     DC,MC,SC,AC,MAC:Integer;
     HP,MP:Integer;
     Hit:integer;
     Speed:integer;
  end;

  TShortMessage=packed record
     Ident :WORD;
     Msg   :WORD;
  end;


  TCharDesc= packed Record
     Feature:Integer;
     Status:Integer;
  end;


{//lorran modi 2004-07-12
  TMessageBodyW=Record
     Param1:integer;
     Param2:integer;
     Tag1:integer;
     Tag2:integer;
  end;
}
  TMESSAGEBODYW = packed record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end ;


  TMessageBodyWL=packed Record
     lParam1,lParam2:longint;
     lTag1,lTag2:longint;
  end;



  PTClientGoods=^TClientGoods;
  TClientGoods=packed record
     Name:string[16];
     SubMenu:Integer;
     Price:Integer;
     Stock:integer;
     Grade:integer;
  end;

type
  TFEATURE = packed record
    Gender: BYTE;
    Weapon: BYTE;
    Dress: BYTE;
    Hair: BYTE;
  end;


function  MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:smallint):TDefaultMessage;
function  UpInt(i:double):integer;

Function  RACEfeature(Feature:Integer):byte;
Function  WEAPONfeature(Feature:Integer):byte;
Function  HAIRfeature(Feature:Integer):byte;
Function  DRESSfeature(Feature:Integer):byte;
Function  APPRfeature(Feature:Integer):Word;
  function Horsefeature(cfeature:integer):Byte;
  function Effectfeature(cfeature:integer):Byte;
//Function  RACEfeature(Feature:Word):smallint;
//Function  HAIRfeature(Feature:Word):byte;
//Function  DRESSfeature(Feature:Word):byte;
//Function  APPRfeature(Feature:Word):byte;
//Function  WEAPONfeature(Feature:Word):byte;

function  MakeFeature(Race:byte;Appr,Hair,Dress,Weapon:byte):Integer;
implementation

function Horsefeature(cfeature:integer):Byte;
begin
  Result:=LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature:integer):Byte;
begin
  Result:=HiByte(LoWord(cfeature));
end;

function  MakeDefaultMsg (msg:smallint; Recog:integer; param, tag, series:smallint):TDefaultMessage;
begin
    result.Ident:=Msg;
    result.Param:=Param;
    result.Tag:=Tag;
    result.Series:=Series;
    result.Recog:=Recog;
end;

function  UpInt(i:double):integer;
begin
  result:=Ceil(i);
end;


//����Feature���Եķֽ�ͺϳɣ���32λ����16λΪRace��Appr,
//   ��16λ�У�������λ��ʾHair,������6λ��ʾDress,����6λ��ʾWeapon��
//   ��Race=0ʱ,Dress mod 2 ��ʾ�Ա�
//   Race=0ʱ����Ҳ����Ů���е�����Ӧ����ż����Ů��������
//*******��Feature�Ľ��Ϳ����Լ����壬��Raceȡֵ����0..90��Appr:0..9
//*******Hair�����6�ַ��ͣ�3600��ͼƬ��ÿ600��ͼƬһ�ַ��ͣ�����Ů��3
//*******Dress������������Hum.WIL�б�ʾ���ж�����ͼƬ���ж����ַ�װ��Hum.WIL������չ
//*******Weapon��������Weapon.WIL���������ͼƬ��ͬ���ģ�ÿ600����Ӧһ��Appr������Ů
//*********����40800����Ӧ68����������Ů�ϼƣ�

{ //???????
  TFEATURE = record
    Race: BYTE;
    Weapon: BYTE;
    Hair: BYTE;
    Dress: BYTE;
  end;
}

//$0602 1600 =100800000
Function  RACEfeature(Feature:Integer):byte;
begin
  result:=(LoByte(Loword(Feature)) and $3F);
end;

Function  WEAPONfeature(Feature:Integer):byte;
begin
  result:=HiByte(LoWord(Feature));
end;



Function  HAIRfeature(Feature:Integer):byte;
begin
    result:=LoByte(HiWord(Feature));
end;


Function  DRESSfeature(Feature:Integer):byte;
begin
  result:=HiByte(HiWord(Feature));
end;


Function  APPRfeature(Feature:Integer):Word;
begin
  result:=hiword(Feature) ;
//  result:=Loword(Feature) ;
end;

function  MakeFeature(Race:byte;Appr,Hair,Dress,Weapon:byte):Integer;
begin
  result:=MakeLong( MakeWord(Race,weapon),MakeWord(Hair,Dress));
end;

end.
