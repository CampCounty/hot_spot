import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:hot_spot/src/features/authentication/presentation/profileScreen.dart';

class FangDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fang Details'),
        backgroundColor: Color.fromARGB(255, 191, 226, 193),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fang.bildUrl != null && fang.bildUrl!.isNotEmpty)
              Image.network(
                fang.bildUrl!,
                width: double.infinity,
                height: 300,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(fangId: fang.id),
                  FollowButton(userId: fang.userID),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fang.fischart,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DetailRow(
                      title: 'Größe',
                      value: '${fang.groesse.toStringAsFixed(2)} cm'),
                  DetailRow(
                      title: 'Gewicht',
                      value: '${fang.gewicht.toStringAsFixed(2)} g'),
                  DetailRow(
                      title: 'Gefangen am',
                      value: DateFormat('dd.MM.yyyy').format(fang.datum)),
                  DetailRow(title: 'Gewässer', value: fang.gewaesser),
                  if (fang.angelmethode != null)
                    DetailRow(title: 'Angelmethode', value: fang.angelmethode!),
                  if (fang.naturkoeder != null)
                    DetailRow(title: 'Naturköder', value: fang.naturkoeder!),
                  SizedBox(height: 16),
                  Text(
                    'Gefangen von: ${fang.username}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final currentUserId = authRepository.getCurrentUserId();
                      if (currentUserId.isNotEmpty) {
                        final userProfile = await databaseRepository
                            .getUserProfile(fang.userID);
                        if (userProfile != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileWidget(
                                databaseRepository: databaseRepository,
                                authRepository: authRepository,
                                userId: fang.userID,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Benutzerprofil nicht gefunden')),
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
                ],
              ),
            ),
          ],
        ),
      ),
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
