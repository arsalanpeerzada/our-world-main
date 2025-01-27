import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourworldmain/common/size_config.dart';
import 'package:ourworldmain/constants/string_constants.dart';
import 'package:ourworldmain/join_us/WebViewPage.dart';

class JoinUsScreen extends StatelessWidget {
  const JoinUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -(SizeConfig.screenWidth * 0.5),
              left: -SizeConfig.screenWidth * 0.125,
              child: Container(
                height: SizeConfig.screenWidth * 1.2,
                width: SizeConfig.screenWidth * 1.25,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 122, 196, 251),
                      Color.fromARGB(255, 109, 127, 251),
                    ], stops: [
                      0.5,
                      1
                    ]),
                    shape: BoxShape.circle),
              )),
          Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.chevron_left,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                        child: Text(joinUs.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ),
                  Container(width: 50, height: 50)
                ],
              )),
          Positioned(
              top: SizeConfig.screenWidth * 0.4,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/saveearth.png',
                    height: SizeConfig.screenWidth * 0.5,
                    width: SizeConfig.screenWidth * 0.5),
              )),
          Positioned(
              top: SizeConfig.screenWidth * 0.9,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: SizeConfig.screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => WebViewPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Set the background color to blue
                          foregroundColor: Colors.white, // Set the text color to white
                        ),
                        child: Text(joinUs.tr),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SelectableText(
                        '''Are you thinking about marriage and traveling at the same time?
Are you looking for financial security?
Are you seeking an opportunity to travel and settle in a specific country?
Join us and we will secure your future.

Now, through our program, become a partner in an international company and own a financial balance to secure your future.

The process is simple and secure as follows:

Contact us on the travel group.
The setup cost is \$200 per member.
You can collect this amount through our app, Play. Services. Commerce. Events...
We need 200 partners for each company.
The company deducts a 25% fee whether the company opens the country or not. Any financial amounts deposited through our app will be subject to a 25% deduction. Additionally, an initial 50% will be deducted.

Overall, if using our app, the deduction is 75%.
For any country, we will provide you with a property letter. The same deduction percentage applies.

As explained in the details:

Establishing a company involves adding partners, each with a 4% share.
For example, with 20 partners:
The World app will establish the company and open a bank account.
Partners will pay the company setup fees and all associated costs.

25% of the company shares will be registered under World, which includes tax fees, renewal, and legal services such as lawyers, accountants, and auditors.

The remaining 75% of the shares will be divided among all members.
Each partner will work within our app in Play, Commerce, Services.

Any profits they make will be added to their personal account in the company with an invoice in their name.
Once each partner reaches a balance of \$15,000, they can apply to travel to any country, and we will provide them with a financial ownership letter, account statement, or bank certificate.

Main Conditions:
No member or group, regardless of their share percentage, is allowed to:

- Claim loans or financing in the company's name.
- Settle debts.
- Pay fines.
- Receive or send money to any third parties, known or unknown.
- Receive or send money from/to stores, individuals, or companies.

The main goal of the company:

- Provide financial security for members of World app.
- Assist in traveling.

Required:
A valid passport, with matching information to any bank account, residence, or national ID.

We do not send money to countries suffering from wars, blockades, or special circumstances.
We do not support or deal with individuals, entities, or organizations with political affiliations or involvement.
We do not support bullying, sectarianism, or terrorism in any form.

There are no guarantees, and the World app does not commit to any guarantees, fines, or legal liabilities.

We are not responsible for misuse by any user.

The company headquarters will be either in Oman or the United States.

If you are in certain disaster-stricken countries, there are easier countries to enter and establish a bank account.
There are also countries where entry is difficult even with capital.

There are no guarantors.''',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

