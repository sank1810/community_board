import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('post detail page')));
  }
}
