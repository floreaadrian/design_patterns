import 'package:design_patterns/HtmlDeorator/my_html.dart';
import 'package:design_patterns/HtmlDeorator/my_html_impl.dart';
import 'package:design_patterns/HtmlDeorator/my_tag.dart';
import 'package:design_patterns/HtmlDeorator/tags/b_tag.dart';
import 'package:design_patterns/HtmlDeorator/tags/div_tag.dart';
import 'package:design_patterns/HtmlDeorator/tags/ol_tag.dart';
import 'package:design_patterns/HtmlDeorator/tags/p_tag.dart';
import 'package:design_patterns/fact_model.dart';
import 'package:design_patterns/poxy_design/db_interface.dart';
import 'package:design_patterns/poxy_design/db_proxy.dart';
import 'package:design_patterns/state_design/custom_button.dart';
import 'package:design_patterns/stmp_sever.dart';
import 'package:enough_mail/mail_address.dart';
import 'package:enough_mail/message_builder.dart';
import 'package:enough_mail/smtp/smtp_client.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:tuple/tuple.dart';

import 'iterator_design/facts.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomButton customButton = CustomButton.instance;
  final String noFactsStr =
      'No more new facts.. Tap the "Fetch more data" to get more facts!';
  Facts facts = new Facts();
  Color buttonColor = Colors.white;
  String buttonText = "None";
  Iterator iterator;
  bool nextButtonDisabled = true;
  bool seeSavedDisabled = true;
  String currentFact = "None";
  bool factsAreShown = false;
  Future getData;
  final DbInteface dbProxy = new DbProxy();

  @override
  void initState() {
    super.initState();
    facts.fetchMore().then((_) {
      iterator = facts.createIterator();
      iterator.first();
      currentFact = iterator.curentItem();
      setState(() {
        nextButtonDisabled = false;
        seeSavedDisabled = false;
      });
    });
  }

  Widget createSavedList(BuildContext context) {
    return FutureBuilder(
      future: getData,
      builder: (context, itemsSnap) {
        if (itemsSnap.connectionState == ConnectionState.done) {
          if (itemsSnap.data == null) return Container();
          return ListView.builder(
            itemCount: itemsSnap.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(itemsSnap.data[index].fact),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    dbProxy.deleteFact(itemsSnap.data[index].id).then((_) {
                      setState(() {
                        getData = dbProxy.getAllFacts();
                      });
                    });
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget factsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                color: buttonColor,
                onPressed: () async {
                  bool shouldRenewFact = iterator.isDone();
                  setState(() {
                    nextButtonDisabled = true;
                  });
                  facts.fetchMore().then((_) {
                    setState(() {
                      nextButtonDisabled = false;
                      if (shouldRenewFact) {
                        iterator.next();
                        currentFact = iterator.curentItem();
                      }
                    });
                  });
                },
                child: Text("Fetch more data"),
              ),
              RaisedButton(
                onPressed: nextButtonDisabled && seeSavedDisabled
                    ? null
                    : () async {
                        Color color = customButton.change();
                        setState(() {
                          buttonColor = color;
                        });
                        if (!iterator.isDone()) {
                          iterator.next();
                          setState(() {
                            currentFact = iterator.curentItem();
                          });
                        } else {
                          setState(() {
                            currentFact = noFactsStr;
                          });
                        }
                      },
                color: buttonColor,
                child: Text("Next fact"),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(currentFact),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: currentFact == noFactsStr
                    ? null
                    : () async {
                        setState(() {
                          seeSavedDisabled = true;
                        });
                        dbProxy.addFact(currentFact).then((_) {
                          setState(() {
                            getData = dbProxy.getAllFacts();
                            seeSavedDisabled = false;
                          });
                        });
                      },
                color: buttonColor,
                child: Text("Save the fact!"),
              ),
              RaisedButton(
                onPressed: seeSavedDisabled
                    ? null
                    : () async {
                        setState(() {
                          if (!factsAreShown) {
                            getData = dbProxy.getAllFacts();
                          }
                          factsAreShown = !factsAreShown;
                        });
                      },
                color: buttonColor,
                child: Text(factsAreShown
                    ? "Hide the saved facts!"
                    : "See tha saved facts!"),
              ),
            ],
          ),
          factsAreShown
              ? Expanded(child: createSavedList(context))
              : Container()
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: factsWidget(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mail),
        tooltip: "Send the facts to an email!",
        onPressed: () async {
          List<FactModel> facts = await dbProxy.getAllFacts();
          String message = facts.map((f) => '<li>$f</li>').join("\n");
          MyHtml myHtml = MyHtmlImpl(message);
          myHtml = OlTag(myHtml);
          myHtml = BTag(myHtml);
          myHtml = PTag(myHtml);
          myHtml = DivTag(myHtml);
          message = myHtml.create();
          smtpExample(message);
        },
      ),
    );
  }

  Future<void> smtpExample(String message) async {
    var client = SmtpClient('mailtrap.io', isLogEnabled: false);
    String username = '0d6db41a34f6b0';
    String password = '752a6f48c75cb2';
    await client.connectToServer('smtp.mailtrap.io', 2525, isSecure: false);
    var ehloResponse = await client.ehlo();
    if (!ehloResponse.isOkStatus) {
      print('SMTP: unable to say helo/ehlo: ${ehloResponse.message}');
      return;
    }
    var loginResponse = await client.login(username, password);
    if (loginResponse.isOkStatus) {
      var builder = MessageBuilder.prepareMultipartAlternativeMessage();
      builder.from = [MailAddress('My name', 'sender@domain.com')];
      builder.to = [MailAddress('Your name', 'recipient@domain.com')];
      builder.subject = 'Here are your facts!';
      builder.addHtmlText(message);
      var mimeMessage = builder.buildMimeMessage();
      var sendResponse = await client.sendMessage(mimeMessage);
      print('message sent: ${!sendResponse.isFailedStatus}');
    }
  }
}
