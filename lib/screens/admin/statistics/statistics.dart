import 'package:karmana_markaz/screens/admin/students/student_types/filter_screen_wrapper.dart';
import 'package:karmana_markaz/screens/admin/students/student_types/students_filter_screen.dart';
import 'package:karmana_markaz/screens/admin/students/super_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karmana_markaz/screens/admin/students/student_types/free_of_charge_students.dart';
 import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/groups/group_controller.dart';
import '../../../controllers/students/student_controller.dart';
import '../students/student_types/paid_students.dart';
import '../students/student_types/unpaid_students.dart';
import '../teachers/teachers.dart';

class Statistics extends StatelessWidget {


  num calculateTotalPayments(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (currentMonth(paidMonths[j]['paidDate'].toString()) ) {
          value += int.parse(paidMonths[j]['paidSum']);
          if (int.parse(paidMonths[j]['paidSum']) != 0) {}
        }
      }
    }
    return value;
  }

  GroupController groupController = Get.put(GroupController());
  final _formKey = GlobalKey<FormState>();


  num paidStudents(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (currentMonth(paidMonths[j]['paidDate'].toString()) &&
            students[i]['items']['isDeleted'] == false &&
            students[i]['items']['isFreeOfcharge'] == false) {
          value++;
          break;
        }
      }
    }
    return value;
  }

  RxList paidStudentsList(List students) {
    RxList value = [].obs;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (
            students[i]['items']['isDeleted'] == false &&
            students[i]['items']['isFreeOfcharge'] == false) {
          value.add(students[i]);
          break;
        }
      }
    }
    return value;
  }
  List UnpaidStudents(List students) {
     List _students = [];
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      var studyDays = students[i]['items']['studyDays'];
      if (calculateUnpaidMonths(studyDays , paidMonths).contains( generateMonthsList()[ generateMonthsList().length-1]) == true &&
          students[i]['items']['isDeleted'] == false &&
          students[i]['items']['isFreeOfcharge'] == false) {
        _students.add(students[i]);
      }
    }
    return _students;
  }

  num freeOfCharge(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      if (students[i]['items']['isFreeOfcharge'] == true &&
          students[i]['items']['isDeleted'] == false) {
        value++;
      }
    }
    return value;
  }

  StudentController studentController = Get.put(StudentController());
  TeachersController teachersController = Get.put(TeachersController());
  GetStorage box = GetStorage();
  RxList students = [].obs;


  RxBool showBalance = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(

        backgroundColor: dashBoardColor,
        title: Text(
          "Statistics",
          style: appBarStyle.copyWith(color: Colors.white),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('MarkazStudents').where('items.isDeleted',isEqualTo: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     SizedBox(height: Get.height/3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Container(
                         
                           
                           child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1,),
                       
                       
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(112)
                       ),
                         width: 64,
                         height: 64,
                         padding: EdgeInsets.all(6),
                       )
                      ],
                    )
                  ],);
                }
                if (snapshot.hasError) {

                  return Center(child: Text('Error: ${snapshot.error}'));

                }
                // If data is available
                if (snapshot.hasData) {
                  students.clear();

                  for(var item in snapshot.data!.docs){
                    students.add(item);

                  }


                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap:(){
                                Get.to(SuperSearch(students: students));
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Color(0xff74BE73),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Talabalar soni",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${snapshot.data!.docs.where((el) => el['items']['isDeleted'] == false).toList().length}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Icon(
                                          Icons.group,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap:() async {
                               await studentController.fetchGroups();
                                Get.to(FilterScreenWrapper(students: students, groups: studentController.MarkazGroups, paidStudents: paidStudentsList(students),));
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kirim',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                   Obx(()=> Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.spaceBetween,
                                     children: [
                                       showBalance.value == false ? Text('*****',style: TextStyle(color: Colors.white),):
                                       Text(
                                         calculateTotalPayments(snapshot.data!.docs
                                             .toList()) <
                                             1000000
                                             ? '+ ${calculateTotalPayments(snapshot.data!.docs.toList()) / 1000} k'
                                             : '${formatNumber(calculateTotalPayments(snapshot.data!.docs.toList()))} so\'m',
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 12,
                                             fontWeight: FontWeight.w700),
                                       ),
                                       GestureDetector(
                                         onTap:(){
                                           showBalance.value = !showBalance.value;
                                         },


                                         child: Icon(
                                           showBalance.value==false ?  CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill,
                                           color: Colors.white,
                                         ),
                                       )
                                     ],
                                   )) ,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  Teachers(),
                                );
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Color(0xff7481CE),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ustozlar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${teachersController.MarkazTeachers.length}',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 12),
                                        ),
                                        Icon(
                                          Icons.school,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                var list = [];

                                for (int i = 0;i < snapshot.data!.docs.length;i++) {
                                  if (hasDebt(snapshot.data!.docs[i]['items']
                                              ['payments']) ==
                                          false &&
                                      snapshot.data!.docs[i]['items']
                                              ['isDeleted'] ==
                                          false &&
                                      snapshot.data!.docs[i]['items']
                                              ['isFreeOfcharge'] ==
                                          false) {
                                    list.add(snapshot.data!.docs[i]);
                                  }
                                }

                                Get.to(PaidStudents(students: list));
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: CupertinoColors.systemGreen,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "To'lov qilganlar",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          paidStudents(
                                                  snapshot.data!.docs.toList())
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Icon(
                                          CupertinoIcons.check_mark_circled_solid,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {


                                Get.to(UnPaidStudents(students: UnpaidStudents(snapshot.data!.docs.toList())));
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Qarzdorlar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${UnpaidStudents(snapshot.data!.docs.toList()).length}',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 12),
                                        ),
                                        Icon(
                                          Icons.access_time_sharp,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(FreeOfChargeds());
                              },
                              child: Container(
                                height: Get.height / 10,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: CupertinoColors.systemYellow,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Imtiyozli talabalar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          freeOfCharge(
                                                  snapshot.data!.docs.toList())
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Icon(
                                          Icons.verified,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  );
                  // return  ListView.builder(
                  //   itemCount:snapshot.data!.docs.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     var element = snapshot.data!.docs
                  //     [index]['items'];
                  //
                  //   },
                  // );
                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
