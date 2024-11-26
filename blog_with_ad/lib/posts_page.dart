import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_manager.dart'; // Import AdManager to use the banner and interstitial ads

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool isLoading = true;
  List posts = []; 

  @override
  void initState() {
    super.initState();
    AdManager.initialize();  
    fetchPosts();  
  }

  Future<void> fetchPosts() async {
    
    await Future.delayed(Duration(seconds: 2)); 
    setState(() {
      posts = List.generate(10, (index) => {'title': 'Post $index', 'excerpt': 'Post excerpt $index'}); 
      isLoading = false;
    });
  }

  @override
  void dispose() {
    AdManager.dispose();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: Column(
        children: [
          // Banner Ad
          Container(
            alignment: Alignment.center,
            child: AdManager.bannerAd != null
                ? SizedBox(
                    width: AdManager.bannerAd.size.width.toDouble(),
                    height: AdManager.bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: AdManager.bannerAd),
                  )
                : Container(), 
          ),

        
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())  
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                post['excerpt'],
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger Interstitial Ad on Button Click
          AdManager.showInterstitialAd();
        },
        child: Icon(Icons.ad_units),
        tooltip: 'Show Interstitial Ad',
      ),
    );
  }
}
