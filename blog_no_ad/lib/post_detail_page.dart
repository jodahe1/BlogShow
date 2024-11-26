import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final post;
  final bool isSelected;
  PostDetailPage({required this.post, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final title = post['title']['rendered'];
    final content = post['content']['rendered'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                stripHtml(content),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: isSelected
          ? Colors.blue[100]
          : Colors.white, // Keep the color for the selected post
    );
  }

  String stripHtml(String htmlString) {
    final document = RegExp(r'<[^>]*>').allMatches(htmlString);
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
