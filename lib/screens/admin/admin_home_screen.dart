import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karmana_markaz/screens/admin/groups/groups.dart';
import 'package:karmana_markaz/screens/admin/statistics/monthly_statistics/monthly_statistics.dart';
import 'package:karmana_markaz/screens/admin/statistics/statistics.dart';
import 'package:karmana_markaz/screens/admin/students/students.dart';
import 'package:karmana_markaz/screens/admin/teachers/teachers.dart';
import 'package:upgrader/upgrader.dart';
import '../../constants/theme.dart';

class AdminHomeScreen extends StatelessWidget {
  static RxInt currentIndex = 0.obs;
   GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: homePagebg,
          body: UpgradeAlert(
            upgrader: Upgrader(
                minAppVersion: '1.0.0+12',
                appcastConfig: AppcastConfiguration(
                  supportedOS: ['android'],
                  url: "",
                )),
            child: Container(
              height: Get.height,
              // padding: EdgeInsets.only(left: 16,right: 16,top: 16),
              child: box.read('isLogged') == '0094'  ? [
                AdminGroups(),
                AdminStudents(),
                Teachers(),
                MonthlyStatistics(),
                Statistics()

              ].obs[currentIndex.value]: [
                AdminGroups(),
                AdminStudents(),
                MonthlyStatistics(),
                Statistics()

              ].obs[currentIndex.value],
            ),
          ),
          bottomNavigationBar:box.read('isLogged') == '0094'  ? BottomNavigationBar(

            backgroundColor: Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.black,
            currentIndex: currentIndex.value,
            onTap: (int index) {
              currentIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch),
                label: 'Guruhlar'.tr.capitalizeFirst,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.group_sharp),
                label: 'Talabalar'.tr.capitalizeFirst,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Ustozlar'.tr.capitalizeFirst,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.warning_rounded),
                label: 'Qarzdorlar'.tr.capitalizeFirst,
              ), BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistika'.tr.capitalizeFirst,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.groups),
              //   label: 'Groups'.tr.capitalizeFirst,
              // ),
            ],
          ):BottomNavigationBar(

            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.black,
            currentIndex: currentIndex.value,
            onTap: (int index) {
              currentIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: 'Groups'.tr.capitalizeFirst,
              ),

              BottomNavigationBarItem(
                icon:Icon(Icons.group),
                label: 'Students'.tr.capitalizeFirst,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning_rounded),
                label: 'Debtors'.tr.capitalizeFirst,
              ), BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistics'.tr.capitalizeFirst,
              ),


              // BottomNavigationBarItem(
              //   icon: Icon(Icons.groups),
              //   label: 'Groups'.tr.capitalizeFirst,
              // ),
            ],
          ),
        ));
  }
}
