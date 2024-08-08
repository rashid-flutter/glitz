import 'package:flutter/material.dart';
import 'package:glitz/glitz_ai/constants/consts.dart';
import 'package:glitz/glitz_ai/model/ai_message.dart';
import 'package:glitz/glitz_ai/widget/ai_message_card.dart';
import 'package:glitz/helper/dialogs.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  final list = <AiMessage>[
    AiMessage(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
  ];
  //?ask question in ai bot
  Future<void> askQuestion() async {
    textC.text = textC.text.trim();
    if (textC.text.isNotEmpty) {
      //*user
      list.add(AiMessage(msg: textC.text, msgType: MessageType.user));
      list.add(AiMessage(msg: '', msgType: MessageType.bot));
      setState(() {});
      scrollDown();
      final res = await getAnswer(textC.text);

      //?ai bot
      list.removeLast();
      list.add(AiMessage(msg: res, msgType: MessageType.bot));
      scrollDown();

      setState(() {});

      textC.text = '';
      return;
    }
    Dialogs.showSnackBar(context, 'Ask Something!');
  }

  //?for moving end message
  void scrollDown() {
    scrollC.animateTo(scrollC.position.minScrollExtent,
        duration: const Duration(microseconds: 500), curve: Curves.ease);
  }

  //?get answer from google gimini ai
  Future<String> getAnswer(final String question) async {
    try {
      //TODO - Google Gemini API Key - https://aistudio.google.com/app/apikey
      const apiKey = GEMINI_API_KEY;
      if (apiKey.isEmpty) {
        return 'API key required\nChange in Ai Screen Codes';
      }
      final model =
          GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);
      return res.text!.trim();
    } catch (e) {
      return 'Something went wrong (Try again in sometime)';
    }
  }

  @override
  void dispose() {
    textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your AI Assistant'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            //*text input Field
            Expanded(
              child: TextFormField(
                controller: textC,
                textAlign: TextAlign.center,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  filled: true,
                  isDense: true,
                  hintText: 'Ask me anything you want...',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ),
            //for adding some space
            const SizedBox(width: 8),

            //send button
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: IconButton(
                onPressed: askQuestion,
                icon: const Icon(Icons.send_outlined,
                    color: Colors.white, size: 28),
              ),
            )
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        controller: scrollC,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .02,
            bottom: MediaQuery.of(context).size.height * .1),
        children: list.map((e) => AiMessageCard(message: e)).toList(),
      ),
    );
  }
}
