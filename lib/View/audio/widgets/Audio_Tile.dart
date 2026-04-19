import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioTile extends StatelessWidget {
  final String? surahName;
  final int? totalAyahs;
  final int? number;
  final VoidCallback onTap;
  const AudioTile({
    super.key,
    this.surahName,
    this.totalAyahs,
    this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColors.primaryBgColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: AppColors.vigGrad1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(children: [
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.splashGrad1),
              child: Text((number).toString(),style: AppFonts.montserratStyle(color: AppColors.primaryTextColor,size: 16,weight: FontWeight.bold),),
            ),SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,children: [Text(surahName!,textAlign: TextAlign.end,style: AppFonts.montserratStyle(color: AppColors.secondaryTextColor,size: 20,weight: FontWeight.bold),),SizedBox(height: 3,),Text("Total Ayahs : $totalAyahs", style: AppFonts.montserratStyle(color: AppColors.vigGrad2,size: 16),)],
            ),Spacer(),Icon(Icons.play_circle_fill_rounded,color: AppColors.splashGrad2,)
          ],),
        ),
      ),
    );
  }
}
