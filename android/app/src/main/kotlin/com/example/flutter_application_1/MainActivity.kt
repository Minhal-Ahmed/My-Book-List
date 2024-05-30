package com.example.flutter_application_1

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()



import com.google.android.gms.ads.MobileAds

class MainActivity : AppCompatActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    MobileAds.initialize(this) {}
  }
}