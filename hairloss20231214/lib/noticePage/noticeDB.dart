import 'dart:async';

import 'package:hairloss/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:intl/intl.dart';

import '../config/mySQLConnector.dart';
import '../menuPage/login_tmp.dart';

Future<void> save_forum(String id, String title, String author, String content) async{
  final conn = await dbConnector();

  try {
    await conn.execute(
      "INSERT INTO Forum (id, post_title, post_author, post_content) VALUES (:id, :title, :author, :content)",
      {
        "id": id,
        "title": title,
        "author": author,
        "content": content,
      },
    );
    print("forum insert successful");
  } catch (e) {
    print("Error inserting data: $e");
  }
}

// 게시판 db에서 가져오기
class ForumPost {
  String id;
  int postNum;
  String title;
  String author;
  String content;
  DateTime date;
  int likeCount;

  ForumPost({
    required this.id,
    required this.postNum,
    required this.title,
    required this.author,
    required this.content,
    required this.date,
    required this.likeCount,
  });
}

Future<List<ForumPost>> loadForum() async {
  final conn = await dbConnector();

  List<ForumPost> forumDataList = [];

  try {
    IResultSet? result = await conn.execute(
      "SELECT * FROM Forum",
    );

    print("게시판 데이터 검색");

    for (final row in result.rows) {
      final id = row.colAt(0);
      final postNum = row.colAt(1);
      final titles = row.colAt(2);
      final authors = row.colAt(3);
      final contents = row.colAt(4);
      final dates = row.colAt(5);
      final likeCounts = row.colAt(6);

      final convertDate = DateTime.parse(dates!);
      ForumPost forumPost = ForumPost(
        id: id as String,
        postNum: int.parse(postNum!),
        title: titles as String,
        author: authors as String,
        content: contents as String,
        date: convertDate,
        likeCount: int.parse(likeCounts!),
      );

      forumDataList.add(forumPost);
    }
  } catch (e) {
    print("데이터 가져오기 오류: $e");
  }

  // 연결 닫기
  await conn.close();

  // 모든 행을 포함하는 리스트 반환
  return forumDataList;
}

// 댓글 저장하기
Future<void> save_comment(String commentId, String postId, int postNum, String content) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
      "INSERT INTO comment (post_id, post_num, comment_id, comment_content) VALUES (:postId, :postNum, :commentId, :commentContent)",
      {
        "postId": postId,
        "postNum": postNum,
        "commentId": commentId,
        "commentContent": content,
      },
    );
    print("forum insert successful");
  } catch (e) {
    print("Error inserting data: $e");
  }
}

// 댓글 db에서 가져오기
class ForumComment {
  String comment_id;
  int comment_num;
  String comment_content;

  ForumComment({
    required this.comment_id,
    required this.comment_num,
    required this.comment_content,
  });
}

Future<List<ForumComment>> loadComment(String postId, int postNum) async {
  final conn = await dbConnector();

  List<ForumComment> forumDataList = [];

  try {
    IResultSet? result = await conn.execute(
      "SELECT comment_id, comment_num, comment_content FROM comment WHERE post_id= :postId and post_num= :postNum order by comment_num ASC",
      {
        "postId": postId,
        "postNum": postNum,
      },
    );

    print("게시판 댓글 검색");

    for (final row in result.rows) {
      final commentId = row.colAt(0);
      final commentNum = row.colAt(1);
      final commentContent = row.colAt(2);

      ForumComment forumComment = ForumComment(
        comment_id: commentId as String,
        comment_num: int.parse(commentNum!),
        comment_content: commentContent as String,
      );

      forumDataList.add(forumComment);
    }
  } catch (e) {
    print("commentdb에서 데이터 가져오기 오류: $e");
  }

  // 연결 닫기
  await conn.close();

  // 모든 행을 포함하는 리스트 반환
  return forumDataList;
}

//하트 증가
// 정보 수정
Future<void> likeplus(String id, int postNum) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 하트 증가하기 위한 db 접속
  try {
    await conn.execute(
      "UPDATE Forum SET like_count = like_count + 1 WHERE id = :id AND post_num = :postNum;",
      {
        "id": id,
        "postNum": postNum,
      },
    );
    print("하트 증가 완료");
  }catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}