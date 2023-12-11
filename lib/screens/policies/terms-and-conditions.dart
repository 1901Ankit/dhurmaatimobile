import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../main_profile.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Terms and Conditions",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Scrollbar(
            controller: ScrollController(),
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  // Text("Terms and Conditions",textAlign: TextAlign.center, style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Text("Terms of Use",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Last updated:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(" November 10, 2022",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("AGREEMENT TO TERMS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "These Terms of Use constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and Dhur Maati (“we,” “us” or “our”), concerning your access to and use of the Dhur Maati application as well as any other media form, media channel, mobile application related, linked, or otherwise connected thereto (collectively, the “Application”).You agree that by accessing the Application, you have read, understood, and agree to be bound by all of these Terms of Use. If you do not agree with all of these Terms of Use, then you are expressly prohibited from using the Application and you must discontinue use immediately.Supplemental Terms of Use or documents that may be posted on the Application from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Use at any time and for any reason.We will alert you about any changes by updating the “Last updated” date of these Terms of Use, and you waive any right to receive specific notice of each such change.It is your responsibility to periodically review these Terms of Use to stay informed of updates. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms of Use by your continued use of the Application after the date such revised Terms of Use are posted.The information provided on the Application is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country.Accordingly, those persons who choose to access the Application from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Terms and Conditions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "The Application is intended for users who are at least 18 years old. Persons under the age of 18 are not permitted to register for the Application.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("INTELLECTUAL PROPERTY RIGHTS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Unless otherwise indicated, the Application is our proprietary property and all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics on the Application (collectively, the “Content”) and the trademarks, service marks, and logos contained therein (the “Marks”) are owned or controlled by us or licensed to us, and are protected by copyright and trademark laws and various other intellectual property rights and unfair competition laws of the India, foreign jurisdictions, and international conventions.The Content and the Marks are provided on the Application “AS IS” for your information and personal use only. Except as expressly provided in these Terms of Use, no part of the Application and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission.Provided that you are eligible to use the Application, you are granted a limited license to access and use the Application and to download or print a copy of any portion of the Content to which you have properly gained access solely for your personal, non-commercial use. We reserve all rights not expressly granted to you in and to the Application, the Content and the Marks.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("USER REPRESENTATIONS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "By using the Application, you represent and warrant that:",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "(1) all registration information you submit will be true, accurate, current, and complete;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(2) you will maintain the accuracy of such information and promptly update such registration information as necessary;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(3) you have the legal capacity and you agree to comply with these Terms of Use;",
                      style: TextStyle(fontSize: 16)),
                  Text("(4) you are not under the age of 18;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(5) not a minor in the jurisdiction in which you reside, or if a minor, you have received parental permission to use the Application;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(6) you will not access the Application through automated or non-human means, whether through a bot, script, or otherwise;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(7) you will not use the Application for any illegal or unauthorized purpose;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(8) your use of the Application will not violate any applicable law or regulation.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Application (or any portion thereof).",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(9) Dhur Maati collects location data to enable location specific display of relevant product in the application. Based on the location of the customer relevant products which are available in that radius range only will be shown to the customer for purchase even when the application is closed or not in use.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "(10) Dhur Maati collects location data to enable available product details even when the app is closed or not in use and it is also used to support advertising.",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("USER REGISTRATION",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "You may be required to register with the Application. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("PROHIBITED ACTIVITIES",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "You may not access or use the Application for any purpose other than that for which we make the Application available. The Application may not be used in connection with any commercial endeavours except those that are specifically endorsed or approved by us.",
                      style: TextStyle(fontSize: 16)),
                  Text("As a user of the Application, you agree not to:",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "systematically retrieve data or other content from the Application to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "make any unauthorized use of the Application, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretences.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "use a buying agent or purchasing agent to make purchases on the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "use the Application to advertise or offer to sell goods and services.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "circumvent, disable, or otherwise interfere with security-related features of the Application, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Application and/or the Content contained therein.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "engage in unauthorized framing of or linking to the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords;",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "make improper use of our support services or submit false reports of abuse or misconduct.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "interfere with, disrupt, or create an undue burden on the Application or the networks or services connected to the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "attempt to impersonate another user or person or use the username of another user.",
                      style: TextStyle(fontSize: 16)),
                  Text("sell or otherwise transfer your profile.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "use any information obtained from the Application in order to harass, abuse, or harm another person.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "use the Application as part of any effort to compete with us or otherwise use the Application and/or the Content for any revenue-generating endeavour or commercial enterprise.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "attempt to bypass any measures of the Application designed to prevent or restrict access to the Application, or any portion of the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Application to you.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "delete the copyright or other proprietary rights notice from any Content.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "copy or adapt the software, including but not limited to Flash, PHP, HTML, JavaScript, or other code.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party’s uninterrupted use and enjoyment of the Application or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats (“gifs”), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as “spyware” or “passive collection mechanisms” or “pcms”).",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Application, or using or launching any unauthorized script or other software.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "disparage, tarnish, or otherwise harm, in our opinion, us and/or the Application.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "use the Application in a manner inconsistent with any applicable laws or regulations.",
                      style: TextStyle(fontSize: 16)),
                  Text("", style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

               
                   SizedBox(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width/4, // specific value

                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfile()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(
                                          // side: BorderSide(
                                          //   color: Colors.black, //<-- SEE HERE
                                          // ),
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        primary: Color.fromARGB(
                                            255, 193, 63, 40), // background

                                        // foreground
                                      ),
                                      child: Text(
                                        "I Agree",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            fontFamily: 'Poppins'),
                                      ),
                                    )),
                                         ],
                  ),
                                SizedBox(
                                  height: 10,
                                )
                ],
              ),
            )),
      ),
    ));
  }
}
