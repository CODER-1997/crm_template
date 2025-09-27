import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:karmana_markaz/constants/custom_widgets/student_card_widget/gradient_container.dart';

class karmana_markazStudentCard extends StatelessWidget {
  final Map item;
 final String position;
    karmana_markazStudentCard({super.key, required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
       ),
      child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(children: [
          SizedBox(width: 4,),

          Text("$position",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito'

          ),),
          SizedBox(width: 12,),
          GradientLetterBox(letter: item['name'].toString().toUpperCase().substring(0,1)+""+item['surname'].toString().toUpperCase().substring(0,1), position: position,)
          ,SizedBox(width: 16,)
        ,    Text(item['name'].toString().toUpperCase()+" "+item['surname'].toString().toUpperCase(),style: TextStyle(
            color: CupertinoColors.black,
            fontSize: 12,
             fontFamily: 'Lilita'
          ),)
        ],),
        SizedBox(width: 8,),
                 Container
        (alignment:Alignment.center,
        width: 56,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.orangeAccent,Colors.yellowAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Text("--->",style:
        TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,

        ),
        textAlign: TextAlign.center,),)
      ],
    ),);
  }
}
