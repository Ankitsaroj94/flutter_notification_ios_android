step 1

firebase messeging
firebase core
local notification/awesome noti
permission handler 

step2 

flutterfire init(insure package name , nbundle id are correct )

step 3

fireabse cloud messeging - apple (add keys , that we generate from developer.apple.com sandbox, production both )

step 4

android menifest (add post notification ) permission 

step 5 

podfile( network handlers target config for notification) for permissoin handler 

step 6 

insure  to initialize firebase in main ,
make permission flow to take notifoication permission , 
make backgroud handler of firebase and insure to initialize firebase in bagHandler also,make sure to add vm entry point decoration.
 
 step 7 
 
create channel for android (initialize flutter local noti),
add firebase forgroud noti handler for android (show noti using flutter notification plugin) make sure to pass payload in this step using jsonEncode,

step 8

check for initial noti(if app opened using notificaion ) handle , 
whenever bg noti is tapped handle it ,



 







