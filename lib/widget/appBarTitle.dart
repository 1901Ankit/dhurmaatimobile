import 'package:dhurmaati/Constants/constants.dart';
import 'package:dhurmaati/screens/main_dashboard_page.dart';
import 'package:dhurmaati/screens/notification_screen.dart';
import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image(
                width: 20,
                height: 30,
                image: AssetImage(Constant.Menu),
              ),
              //  const Icon(
              //   Icons.menu,
              //   color: Colors.red,
              //   size: 44, // Changing Drawer Icon Size
              // ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        // Icon(
        //   Icons.list,
        //   color: Colors.black,
        // ),
        Container(
          child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashBoard()),
                  (route) => false);
                  // PackageDeliveryTrackingPage()  
            },
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  'assets/images/maatilogo.png',
                  // fit: BoxFit.contain,
                  // height: 48,
                ),
                radius: 22),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NotificationList()),
                (route) => false);
          },
          child: Image(
            width: 20,
            height: 30,
            image: AssetImage(Constant.Bell),
          ),
        )
      ],
    );
  }
}
