import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/profileScreen.dart';

class FangDetailsScreen extends StatefulWidget {
  final FangData fang;
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const FangDetailsScreen({
    Key? key,
    required this.fang,
    required this.databaseRepository,
    required this.authRepository,
  }) : super(key: key);

  @override
  _FangDetailsScreenState createState() => _FangDetailsScreenState();
}

class _FangDetailsScreenState extends State<FangDetailsScreen> {
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final loadedComments =
        await widget.databaseRepository.getComments(widget.fang.id);
    setState(() {
      comments = loadedComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fang Details'),
        backgroundColor: Color.fromARGB(255, 191, 226, 193),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hintergründe/Blancscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.fang.bildUrl != null &&
                    widget.fang.bildUrl!.isNotEmpty)
                  Image.network(
                    widget.fang.bildUrl!,
                    width: double.infinity,
                    height: 500,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        size: 100, color: Colors.grey[600]),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LikeButton(fangId: widget.fang.id),
                      FollowButton(userId: widget.fang.userID),
                      CommentButton(
                        fangId: widget.fang.id,
                        databaseRepository: widget.databaseRepository,
                        authRepository: widget.authRepository,
                        refreshComments: _loadComments,
                      ),
                      Text('${comments.length} Kommentare'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fang.fischart,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                              'Größe: ${widget.fang.groesse.toStringAsFixed(2)} cm',
                              style: TextStyle(fontSize: 16)),
                          if (widget.fang.isPB)
                            Text(
                              ' PB',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                      DetailRow(
                          title: 'Gewicht',
                          value: '${widget.fang.gewicht.toStringAsFixed(2)} g'),
                      DetailRow(
                          title: 'Gefangen am',
                          value: DateFormat('dd.MM.yyyy')
                              .format(widget.fang.datum)),
                      DetailRow(
                          title: 'Gewässer', value: widget.fang.gewaesser),
                      if (widget.fang.angelmethode != null)
                        DetailRow(
                            title: 'Angelmethode',
                            value: widget.fang.angelmethode!),
                      if (widget.fang.koeder != null)
                        DetailRow(title: 'Köder', value: widget.fang.koeder!),
                      if (widget.fang.koederTyp != null)
                        DetailRow(
                            title: 'Ködertyp', value: widget.fang.koederTyp!),
                      if (widget.fang.naturkoeder != null)
                        DetailRow(
                            title: 'Naturköder',
                            value: widget.fang.naturkoeder!),
                      SizedBox(height: 16),
                      Text(
                        'Gefangen von: ${widget.fang.username}',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () async {
                          final currentUserId =
                              widget.authRepository.getCurrentUserId();
                          if (currentUserId.isNotEmpty) {
                            final userProfile = await widget.databaseRepository
                                .getUserProfile(widget.fang.userID);
                            if (userProfile != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileWidget(
                                    databaseRepository:
                                        widget.databaseRepository,
                                    authRepository: widget.authRepository,
                                    userId: widget.fang.userID,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Benutzerprofil nicht gefunden')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Du musst angemeldet sein, um Profile anzusehen')),
                            );
                          }
                        },
                        child: Text('Zum Profil'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Kommentare (${comments.length})',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      _buildCommentsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Column(
      children: comments.map((comment) {
        String username = comment['username'] ?? 'Unbekannt';
        String firstLetter =
            username.isNotEmpty ? username[0].toUpperCase() : '?';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Text(firstLetter),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(comment['commentText'] ?? ''),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final String fangId;

  const LikeButton({Key? key, required this.fangId}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        // TODO: Implementieren Sie hier die Like-Funktionalität
      },
    );
  }
}

class FollowButton extends StatefulWidget {
  final String userId;

  const FollowButton({Key? key, required this.userId}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFollowing ? Icons.person : Icons.person_add,
        color: isFollowing ? Colors.blue : null,
      ),
      onPressed: () {
        setState(() {
          isFollowing = !isFollowing;
        });
        // TODO: Implementieren Sie hier die Follow-Funktionalität
      },
    );
  }
}

class CommentButton extends StatelessWidget {
  final String fangId;
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final Function refreshComments;

  const CommentButton({
    Key? key,
    required this.fangId,
    required this.databaseRepository,
    required this.authRepository,
    required this.refreshComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.comment),
      onPressed: () {
        _showCommentDialog(context);
      },
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String commentText = '';

        return AlertDialog(
          title: Text('Kommentar hinzufügen'),
          content: TextField(
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(hintText: "Gib deinen Kommentar ein"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Kommentieren'),
              onPressed: () async {
                if (commentText.isNotEmpty) {
                  String userId = authRepository.getCurrentUserId();
                  if (userId.isNotEmpty) {
                    String username =
                        await databaseRepository.getUsername(userId);
                    await databaseRepository.addComment(
                        fangId, userId, commentText, username);
                    Navigator.of(context).pop();
                    refreshComments();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kommentar wurde hinzugefügt')),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Du musst angemeldet sein, um zu kommentieren')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bitte gib einen Kommentar ein')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
