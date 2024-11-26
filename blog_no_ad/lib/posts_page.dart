import 'package:flutter/material.dart';
import 'post_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List posts = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  int page = 1;
  final ScrollController _scrollController = ScrollController();
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://blog.bolenav.com/wp-json/wp/v2/posts?page=$page');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          posts.addAll(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isFetchingMore) {
        setState(() {
          isFetchingMore = true;
        });
        page++;
        fetchPosts().then((_) {
          setState(() {
            isFetchingMore = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPress Posts'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  posts.clear();
                  page = 1;
                  isLoading = true;
                });
                fetchPosts();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: posts.length + 1, 
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return isFetchingMore
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }
                  final post = posts[index];
                  final title = post['title']['rendered'];
                  final excerpt = post['excerpt']['rendered'];

                  bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post, isSelected: isSelected),
                        ),
                      );
                    },
                    child: AnimatedScale(
                      scale: isSelected ? 1.05 : 1.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Card(
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isSelected ? 12 : 4, 
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [Colors.blue, const Color.fromARGB(84, 31, 70, 33), const Color.fromARGB(255, 39, 144, 176)], // Same 3-color gradient
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [Colors.blue[300]!, Colors.green[300]!, const Color.fromARGB(255, 200, 104, 146)!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  stripHtml(excerpt),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String stripHtml(String htmlString) {
    final document = RegExp(r'<[^>]*>').allMatches(htmlString);
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
