import 'package:bldevice_connection/constant/colors_const.dart';
import 'package:bldevice_connection/constant/textstyle_constant.dart';
import 'package:bldevice_connection/view/footer_page.dart';
import 'package:bldevice_connection/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formkey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  late Future<void> launched;
  String phoneNumber = '';
  String _launchUrl = 'https://info@arctano.com';

  Future<void> _launchinUrl0(String url) async {
    if (await canLaunch('https://gmail.com')) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _launchinUrl(String url) async {
    if (await canLaunch('https://facebook.com')) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _launchinUrl1(String url) async {
    if (await canLaunch('https://linkindin.com')) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _launchinUrl2(String url) async {
    if (await canLaunch('https://www.google.co.in/maps/place/Arctano.com')) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _launchinUrl3(String url) async {
    if (await canLaunch('https://intagram.com')) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch &url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: kWhiteColor,
          title: const Text(
            'Contact Us',
            style: kXLTextStyle,
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: Text('Get in Touch',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Column(children: const [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Send us message!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
          ]),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(fontSize: 15),
            ),
            controller: namecontroller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name is Required';
              }
              if (value.length < 2) {
                return "Name must be more than one character.";
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              labelStyle: TextStyle(fontSize: 15),
            ),
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'E-mail is required';
              }
              return null;
            },
          ),
          TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Phone no..',
                labelStyle: TextStyle(fontSize: 15),
              ),
              controller: phoneController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mobile no.is required';
                } else if (value.length < 10) {
                  return 'provided mobile number has less than 10 digits';
                } else if (value.length > 10) {
                  return 'provided mobile number has more than 10 digits';
                }
                return null;
              }),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Give short meeage.',
              labelStyle: TextStyle(fontSize: 15),
            ),
            controller: messageController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name is Required';
              }
              if (value.length < 2) {
                return "Name must be more than one character.";
              } else {}
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              child: CustomButton(
                colors: kPrimaryColor,
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    var name = namecontroller.text;
                    var email = emailController.text;
                    var mobile = phoneController.text;
                    var password = messageController.text;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Footer(
                        currentTab: 0,
                      );
                    }));
                  }
                },
                childWidget: const Text('Submit', style: kWhiteLrgTextStyle),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              launched = _makePhoneCall('tel: 9711088018');
            },
            leading: const Icon(
              Icons.phone_callback_outlined,
              size: 20,
            ),
            title: const Text(
              ' 9711088018',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ),
          ListTile(
            onTap: () {
              _launchinUrl0('mailto:info@aanaxagorasr.com');
            },
            leading: const Icon(
              Icons.mail_outline,
              size: 20,
            ),
            title: const Text(
              'info@arctano.com',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ),
          ListTile(
            onTap: () {
              _launchinUrl2(
                  'https://www.google.co.in/maps/place/Arctano+Software+Pvt.+Ltd/@28.6174354,77.3892838,17z/data=!3m1!4b1!4m5!3m4!1s0x390cefea9ba0fb17:0x34b996d18f42aa!8m2!3d28.6174354!4d77.3914725');
            },
            leading: const Icon(
              Icons.people,
              size: 20,
            ),
            title: const Text(
              'R-178 3rd floor,Sector-63,Greater kailash 1, South Delhi, Delhi,India',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CustomButton(
                          onTap: () {
                            _launchinUrl(
                                'https://www.facebook.com/aanaxagoras');
                          },
                          childWidget: Image.asset('assets/facebook.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CustomButton(
                          onTap: () {
                            _launchinUrl1(
                                'https://www.linkedin.com/company/arctano/');
                          },
                          childWidget: Image.asset('assets/link.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CustomButton(
                          onTap: () {
                            _launchinUrl3(
                                'https://instagram.com/arctano?igshid=1a3yvjx6svjjf');
                          },
                          childWidget: Image.asset('assets/insta.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
