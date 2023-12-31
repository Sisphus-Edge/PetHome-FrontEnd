import 'package:flutter/material.dart';

class HorizontalFollowList extends StatelessWidget {
  final double section_width;
  final double section_height;
  final List<String> avatarFiles;


  HorizontalFollowList({required this.avatarFiles, required this.section_width, required this.section_height});

  @override
  Widget build(BuildContext context) {
    List<String> displayedAvatars =
    avatarFiles.length > 5 ? avatarFiles.sublist(0, 5) : avatarFiles;

    return Container(
      child: Column(
        children: [
          buildTitle('别人的小狗'),
          // Divider(
          //   color: Colors.transparent,
          //   // height: section_height *,
          // ),
          Container(
            width: section_width *0.9,
            height: section_height*0.65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayedAvatars.length + 1, // 头像数量+1(用于“更多”按钮)
              itemBuilder: (BuildContext context, int index) {
                if (index == 5 && avatarFiles.length > 5) {
                  return _buildMoreButton(context);
                }
                return _buildAvatar(displayedAvatars[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildTitle(String titleText) {
    return Container(
      height: section_height*0.36,
      width: section_width * 0.9,
      // color: Colors.yellowAccent,
      child: Text(
        titleText,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 20, // 标题字体大小
          fontWeight: FontWeight.w300, // 标题字体粗细
          color: Colors.black54, // 标题颜色
          fontFamily: "ZHUOKAI",
        ),
      ),
    );

  }



  Widget _buildAvatar(String avatarPath) {
    return Container(
      width: section_height*0.6,
      height: section_height*0.6,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      // margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 阴影颜色和不透明度
            // spreadRadius: 1, // 阴影扩散程度
            blurRadius: 5, // 阴影大小
            offset: Offset(2, 3), // 阴影偏移
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(avatarPath),
        ),
      ),
    );
  }


  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: 处理“更多”按钮的点击事件
      },
      child: Container(
        width: section_height*0.6,
        height: section_height*0.6,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black38, // 更多按钮的颜色
        ),
        child: const Center(
          child: Text(
            '更多',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "ZHUOKAI",
              fontSize: 18.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
