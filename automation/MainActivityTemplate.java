package com.example.qa_demo;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.radiumone.effects_sdk.R1PhotoEffectsSDK;

public class MainActivity extends Activity {
  // Declare gallery activity result variable
  public static final int REQUEST_GALLERY_SELECT = 111;

  // Declare an image view for the final image
  private ImageView imageView1;

  // Declare a button for launching SDK
  private Button button1;
  private Button button2;
  private Button button3;

  // For grabbing images from the device gallery
  public final ArrayList<String> imagesPath = new ArrayList<String>();
  Handler handler = new Handler();
  private Bitmap currentBitmap = null;
  public int choice = -1;
  public int count = 0;


  @Override
    protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.activity_main);


      // R1 SDK initialization
      R1PhotoEffectsSDK.getManager().enable(
          getApplicationContext(), 
          "3d2848e0-77a5-0130-64de-22000ac40812", 
          "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkPXxk7BIWriqNE1jRjay4jfioYsVolOJvKoHuyW7svaYCASwCBV4KxQCsvz50UTVLdmddnTlixI5VjXt+3Va6YV2GQf1rT3geuxLen5HpVwtq7bROd9Z9iAvDrqseNWb+iCGnIUrt6k2/9FOESSagTc4/zKcxrprR/zayucJ/iDDPRRrErbZIB8PWi+XT+k04PAiEp0VIr5t37EyTk55mqst+kbxBRLRLMmhWrrVxH+ff7RPFGVaR1z3X5CnTj5mtMb94RS3AzRFAs7gXHqfrzogYrHl8m6sgT+bmSD6V8kYov49cAzRrpE0Enlcr7MGsi7l3NMc4xkjNakEiHsUjwIDAQAB", 
          QA_LINE_A
          );

      // Assign image view
      imageView1 = (ImageView) findViewById(R.id.imageView1);  

      // Assign button and add an event listener
      button1 = (Button) findViewById(R.id.button1);
      button2 = (Button) findViewById(R.id.button2);
      button3 = (Button) findViewById(R.id.button3);

      LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
      params.setMargins(0, 0, 2, 2);
      button1.setLayoutParams(params);
      button2.setLayoutParams(params);
      button3.setLayoutParams(params);


      button1.setOnClickListener(new OnClickListener() {

        @Override
        public void onClick(View arg0) {
          // Open device gallery
          startSelectPicture();   
        }
      });  

      button2.setOnClickListener(new OnClickListener() {

        @Override
        public void onClick(View arg0) {
          // Open device gallery
          previewImage();   
        }
      });  

      button3.setOnClickListener(new OnClickListener() {

        @Override
        public void onClick(View arg0) {
          // Open device gallery
          passToEffects(BitmapFactory.decodeFile(imagesPath.get(choice)));   
        }
      });  

      preselectImage();
      previewImage();

    }

  // Create method that sends user to the device media gallery
  // You could also send the user to the camera
  protected void startSelectPicture() {

    // Declare and assign an intent for the media gallery
    Intent intent = new Intent(Intent.ACTION_PICK,MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
    intent.setType("image/*");

    // Send the user to the device media gallery
    startActivityForResult(intent, REQUEST_GALLERY_SELECT);
  }

  protected void preselectImage(){
    String[] projection = new String[]{
      MediaStore.Images.Media.DATA
    };
    String selection = MediaStore.Images.Media.BUCKET_DISPLAY_NAME + " = ?";
    String[] selectionArgs = new String[] {
      "Camera"
    };

    Uri images = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

    Cursor cur = managedQuery(images,
        projection,
        selection,
        selectionArgs,
        ""
        );

    if (cur.moveToFirst()) {

      int dataColumn = cur.getColumnIndex(
          MediaStore.Images.Media.DATA);

      do {
        imagesPath.add(cur.getString(dataColumn));

      } while (cur.moveToNext());
    }
    count = imagesPath.size()-1;

  }

  protected void previewImage(){
    if(choice < count){
      choice++;
    }
    else {
      choice = 0;
    }                
    imageView1.setImageBitmap(BitmapFactory.decodeFile(imagesPath.get(choice)));

  }

  protected void passToEffects(Bitmap editImage) {   	

    R1PhotoEffectsSDK r1sdk = R1PhotoEffectsSDK.getManager();		

    //String [] customTabs = {
    //    };

    QA_LINE_B

      r1sdk.launchPhotoEffects(
          this,
          editImage,
          true, // Allow user to crop first?
          new R1PhotoEffectsSDK.PhotoEffectsListener() {

            @Override
        public void onEffectsComplete(Bitmap output) {
          if( null == output ){
            return;
          }
          imageView1.setImageBitmap(output);
        }

      @Override
        public void onEffectsCanceled() {
          // user canceled
        }
        } ); 

    // without the SDK, you would have something like this
    // imageView1.setImageBitmap(bitmap);
  }    


  // Create method that handles activity results
  @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

      // Handle activities accordingly
      switch (requestCode) {

        // Handle the image returned from the device media gallery
        case REQUEST_GALLERY_SELECT:

          // Check for error
          if (resultCode == RESULT_OK) {

            // Declare and assign URI to selected device media gallery image
            Uri selectedImageUri = data.getData();		

            //convert image to bitmap            	
            Bitmap bitmap = null;
            try {
              bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), selectedImageUri);
            } catch (FileNotFoundException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            } catch (IOException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            }

            // Send bitmap to SDK
            passToEffects(bitmap);
          }
          break;

      }
    } 
}
