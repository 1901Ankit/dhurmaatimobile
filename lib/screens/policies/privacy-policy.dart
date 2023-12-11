import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_profile.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Privacy Policy",
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
                  Text(
                      "This Privacy Policy describes our policies and procedures on the collection, use and disclosure of your information when you use the Service and tells you about your privacy rights and how the law protects you.We use your Personal data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this Privacy Policy.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Interpretation and Definitions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Interpretation ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "The words have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Definitions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "For the purposes of this Privacy Policy:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Account means a unique account created for You to access our Service or parts of our Service.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Application means the software program provided by the Company downloaded by You on any electronic device, named Dhur Maati",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Avigna Consulting Pte Ltd.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Country refers to: India',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Device means any device that can access the Service such as a computer, a cell phone or a digital tablet.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Personal Data is any information that relates to an identified or identifiable individual.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Service refers to the Application.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analysing how the Service is used.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You mean the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Collecting and Using Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Types of Data Collected",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "While using our service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Email address",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 First name and last name",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Phone number",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Address, State, Province, ZIP/Postal code, City",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Usage Data",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Usage Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Usage Data is collected automatically when using the Service.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Usage Data may include information such as your device's Internet Protocol address (e.g., IP address), browser type, browser version, the pages of our service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "When You access the Service by or through a mobile device, we may collect certain information automatically, including, but not limited to, the type of mobile device You use, your mobile device unique ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We may also collect information that Your browser sends whenever you visit our service or when you access the service by or through a mobile device.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Information Collected while Using the Application",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "While using Our Application, in order to provide features of Our Application, we may collect, with your prior permission:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Information regarding your location",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Pictures and other information from your Device's camera and photo library",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Dhur Maati collects location data to enable location specific display of relevant product in the application. Based on the location of the customer relevant products which are available in that radius range only will be shown to the customer for purchase even when the application is closed or not in use.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Dhur Maati collects location data to enable available product details even when the app is closed or not in use and it is also used to support advertising.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 We are committed to complying with applicable data protection laws.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We use this information to provide features of our service, to improve and customize our service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on your device.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You can enable or disable access to this information at any time, through your device settings.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Use of Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Company may use Personal Data for the following purposes:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 To provide and maintain our Service, including to monitor the usage of our Service.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 To manage Your Account: to manage your registration as a user of the Service. The Personal Data You provide can give you access to different functionalities of the Service that are available to you as a registered user.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services you have purchased or of any other contract with us through the Service.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 To contact You: To contact you by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless you have opted not to receive such information.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 To manage Your requests: To attend and manage your requests to us.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 For business transfers: We may use your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by us about our service users is among the assets transferred.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 For other purposes: We may use your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our service, products, services, marketing and your experience.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We may share Your personal information in the following situations:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 With Service Providers: We may share Your personal information with Service Providers to monitor and analyse the use of our service, to contact You.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 For business transfers: We may share or transfer your personal information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of Our business to another company.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 With Affiliates: We may share your information with our affiliates, in which case we will require those affiliates to honour this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that we control or that are under common control with us.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 With business partners: We may share Your information with our business partners to offer You certain products, services or promotions.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 With other users: when you share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 With Your consent: We may disclose your personal information for any other purpose with your consent.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Retention of Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Company will retain your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of our service, or we are legally obligated to retain this data for longer time periods.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Transfer of Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Company will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your personal data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Delete Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You have the right to delete or request that We assist in deleting the Personal Data that we have collected about you.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Our Service may give you the ability to delete certain information about you from within the Service.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You may update, amend, or delete your information at any time by signing in to your Account, if you have one, and visiting the account settings section that allows you to manage your personal information. You may also contact us to request access to, correct, or delete any personal information that you have provided to us.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please note, however, that we may need to retain certain information when we have a legal obligation or lawful basis to do so.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Disclosure of Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Business Transactions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "If the Company is involved in a merger, acquisition or asset sale, your Personal Data may be transferred. We will provide notice before your Personal Data is transferred and becomes subject to a different Privacy Policy.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Law enforcement",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Other legal requirements",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Comply with a legal obligation",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Protect and defend the rights or property of the Company",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Prevent or investigate possible wrongdoing in connection with the Service",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Protect the personal safety of Users of the Service or the public",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\u2022 Protect against legal liability",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Security of Your Personal Data",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, we cannot guarantee its absolute security.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Children's Privacy",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Our Service does not address anyone under the age of 18. We do not knowingly collect personally identifiable information from anyone under the age of 18. If You are a parent or guardian and you are aware that Your child has provided Us with Personal Data, please contact us. If We become aware that We have collected Personal Data from anyone under the age of 18 without verification of parental consent, we take steps to remove that information from our servers.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "If we need to rely on consent as a legal basis for processing your information and your country requires consent from a parent, we may require Your parent's consent before we collect and use that information.",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Links to Other Websites",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Our Service may contain links to other websites that are not operated by Us. If You click on a third-party link, you will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.We have no control over and assume no responsibility for the content, privacy policies or practices of any third-party sites or services.",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Changes to this Privacy Policy",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "We may update Our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.",
                      style: TextStyle(fontSize: 16)),
                  Text(
                      'We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.',
                      style: TextStyle(fontSize: 16)),
                  Text(
                      "You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.",
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
