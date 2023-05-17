[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/AQPBb0Hq)

<!-- # mpc -->

# MeghRaj: The Indian BioID based cloud service

<!-- ## Getting Started -->

## Problem Statement

**MeghRaj** , this cloud application majorly solves the below mentioned problems:

- Weak Passwords could be exploited.
- Forgetting password, and the forget password option can be used exploited by hackers.
- No way to share any file with the whith the community without restrictions.
- Files shared are not digitally signed by the user/uploader.

So to solve the above mentioned problems we intoduce, **MeghRaj**, a global biometric based file storage and sharing cloud application to upload/download files of limited size to/from the cloud.​A person can only be able to login into his account using his biometric idendity,fingerprint.Also while signing up into the application we provide 2-factor authentication, verifying the email and adding the fingerprint. The files uploded by users are also digitally signed. This cloud application serves as a perfect file sharing platform for communities like, collage, universities etc.

## Design and implementation

Implemented the whole applicaton using flutter, which uses DART programming language. Follow the link to know more about flutter - [Flutter documentation](https://docs.flutter.dev/)

Major features designed of this applications are :

- Fingerprint based Signup.​
- 2-factor authentication while signup(verifying email and adding biometric identity).
- Only fingerprint based Sign In.​
- File uploading & downloading.​(Files that are digitally signed by author)​

Mapping the fingerprint with user credentitals is done using [secure storage](https://pub.dev/packages/flutter_secure_storage), provide by flutter which stores the values in a encrypted form. These stored values are mapped to the fingerprint of the user using the [local_auth](https://pub.dev/packages/local_auth) package provided by flutter. No when ever user wants to sign in into the application he/she should use the biometric identity(fingerprint), which then renders the credentitials from secure storage and makes user sign in.

The following sequence of images describes the signup & sign in process and some pages of the application:

![signup](https://github.com/Mobile-and-Pervasive-Computing-Projects/course-projects-pranith45/blob/main/images/signup.png)
![signin](https://github.com/Mobile-and-Pervasive-Computing-Projects/course-projects-pranith45/blob/main/images/signin.png)
![upload](https://github.com/Mobile-and-Pervasive-Computing-Projects/course-projects-pranith45/blob/main/images/upload.png)
![download](https://github.com/Mobile-and-Pervasive-Computing-Projects/course-projects-pranith45/blob/main/images/download.png)

# Dependencies

One needs to add these dependencies to their pubspec.yaml file. Befor that you need to have flutter installed in your laptop/pc.

```DART
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

  # upload file to firebase
  firebase_core: ^1.0.3
  firebase_storage: ^8.0.3

  # pick file
  file_picker: ^3.0.1

  # store file on device
  path_provider: ^2.0.1

  #local auth
  local_auth: ^2.1.6

  #cloud storage
  cloud_firestore: ^3.1.5

  #firebase auth
  firebase_auth: ^3.3.4
  email_validator: "^2.1.16"

  # creds storage w.r.t biometric
  flutter_secure_storage: ^8.0.0
  dio: ^5.1.1
  gallery_saver: ^2.3.2
  downloads_path_provider_28: ^0.1.2
  permission_handler: ^8.3.0
  file_preview: ^1.1.6
```

After adding dependencies move to the project folder and run the command "flutter run".
To generate the apk file of the app follow the below commands:
-flutter build apk --build-name=<ex:1.0> --buils-number=<ex:2>
