import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hairloss/noticePage/noticeDB.dart';
import 'package:hairloss/const/colors.dart';

import '../menuPage/login_tmp.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<ForumPost>> futureForumData;

  @override
  void initState() {
    super.initState();
    futureForumData = loadForum();
  }

  Future<void> _refreshForumData() async {
    // Load the forum data
    List<ForumPost> refreshedData = await loadForum();

    // Update the state with the refreshed data
    setState(() {
      futureForumData = Future.value(refreshedData);
    });
  }

  void _addNewPost(BuildContext context) async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPostScreen(refreshForumData: _refreshForumData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('게시판'),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshForumData,
        child: FutureBuilder<List<ForumPost>>(
          future: futureForumData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ForumPost forumPost = snapshot.data![index];
                  return Card(
                    color: Colors.lightBlue[50],
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        forumPost.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('작성자: ${forumPost.author}', style: TextStyle(color: Colors.green)),
                          Text('시간: ${DateFormat('y년 MM월 d일 HH:mm').format(forumPost.date)}', style: TextStyle(color: Colors.green)),
                          SizedBox(height: 8),
                          Text(
                            '내용: ${forumPost.content}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              print(forumPost.id);
                              print(forumPost.postNum);
                              likeplus(forumPost.id, forumPost.postNum);
                              _refreshForumData(); // Refresh after liking
                            },
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${forumPost.likeCount}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(forumPost: forumPost),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewPost(context);
        },
        tooltip: '새로운 글 작성',
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  final Function refreshForumData;

  NewPostScreen({required this.refreshForumData});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void _submitPost(BuildContext context) {
    String id = UserData.getId();
    String title = titleController.text;
    String author = authorController.text;
    String content = contentController.text;
    save_forum(id, title, author, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 글 작성'),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: '글쓴이',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                _submitPost(context);
                widget.refreshForumData();
                Navigator.pop(context);
              },
              child: Text(
                '작성 완료',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostDetailScreen extends StatefulWidget {
  final ForumPost forumPost;

  PostDetailScreen({required this.forumPost});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Future<List<ForumComment>>? commentsFuture;

  @override
  void initState() {
    super.initState();
    commentsFuture = loadComment(widget.forumPost.id, widget.forumPost.postNum);
  }

  Future<void> _refresh() async {
    setState(() {
      commentsFuture = loadComment(widget.forumPost.id, widget.forumPost.postNum);
    });
  }

  // Move the refreshComments method to the parent widget
  Future<void> refreshComments() async {
    setState(() {
      commentsFuture = loadComment(widget.forumPost.id, widget.forumPost.postNum);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 상세'),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '제목: ${widget.forumPost.title}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        Text('글쓴이: ${widget.forumPost.author}', style: TextStyle(color: Colors.green)),
                        Text('시간: ${DateFormat('y년 MM월 d일 HH:mm').format(widget.forumPost.date)}', style: TextStyle(color: Colors.green)),
                        SizedBox(height: 16),
                        Text('내용:', style: TextStyle(fontSize: 20, color: Colors.black87)),
                        Text(
                          '${widget.forumPost.content}',
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ForumComment>>(
                future: commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<ForumComment> comments = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        ForumComment comment = comments[index];

                        return Card(
                          color: Colors.lightGreen[100],
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              '댓글: ${comment.comment_content}',
                              style: TextStyle(fontSize: 16, color: Colors.teal),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            CommentInputField(forumPost: widget.forumPost, refreshComments: refreshComments),
          ],
        ),
      ),
    );
  }
}

class CommentInputField extends StatefulWidget {
  final ForumPost forumPost;
  final Function refreshComments; // Pass the refreshComments function as a parameter

  CommentInputField({required this.forumPost, required this.refreshComments});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: '댓글을 작성하세요…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              String commentId = UserData.getId();
              save_comment(commentId, widget.forumPost.id, widget.forumPost.postNum, commentController.text);
              commentController.clear();
              FocusScope.of(context).unfocus();

              // Call the refresh method when the comment is sent
              widget.refreshComments();
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForumScreen(),
  ));
}
