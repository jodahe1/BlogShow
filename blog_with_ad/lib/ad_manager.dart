import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static late BannerAd _bannerAd;
  static InterstitialAd? _interstitialAd; 

 
  static BannerAd get bannerAd => _bannerAd;

  
  static void initialize() {
  
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7925553525282871/1389120822',  
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner Ad Loaded'),
        onAdFailedToLoad: (ad, error) => print('Failed to load banner ad: $error'),
      ),
    );
    _bannerAd.load();

   
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7925553525282871/5207106597',  
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          print('Interstitial Ad Loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  // Show Interstitial Ad
  static void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.show();
      _interstitialAd = null; 
    } else {
      print('Interstitial ad not loaded yet');
    }
  }

  // Dispose Ads
  static void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose(); 
  }
}
