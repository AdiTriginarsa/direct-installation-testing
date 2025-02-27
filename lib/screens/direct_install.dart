import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esim/flutter_esim.dart';

class DirectInstallScreen extends StatefulWidget {
  const DirectInstallScreen({super.key});

  @override
  State<DirectInstallScreen> createState() => _DirectInstallScreenState();
}

class _DirectInstallScreenState extends State<DirectInstallScreen> {
  static const platform = MethodChannel('samples.altero.dev/esim');

  final _textController = TextEditingController();
  late String message;

  bool _isSupportESim = false;
  final _flutterEsimPlugin = FlutterEsim();

  @override
  void initState() {
    message = "";

    initPlatformState();
    _flutterEsimPlugin.onEvent.listen((event) {
      print(event.toString());
      setState(() {
        message = event.toString();
      });
    });
    super.initState();
  }

  Future<void> initPlatformState() async {
    bool isSupportESim;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      isSupportESim = await _flutterEsimPlugin.isSupportESim([]);
    } on Exception {
      isSupportESim = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isSupportESim = isSupportESim;
    });
  }

  Future<void> _installESim2() async {
    setState(() {
      message = "";
    });
    print('Install eSIM button pressed');
    print('Text input: ${_textController.text}');
    await _flutterEsimPlugin.installEsimProfile(_textController.text);
  }

  Future<void> _installESim1() async {
    setState(() {
      message = "";
    });
    print('Install eSIM button pressed');
    print('Text input: ${_textController.text}');

    try {
      final result = await platform.invokeMethod("launchESimSetup",
          {"activation_code": _textController.text});

      if (kDebugMode) {
        print(result);
      }

      if(context.mounted){
        const snackBar = SnackBar(content: Text('Success installing esim'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        message = e.toString();
      });
      const snackBar = SnackBar(content: Text('An error occured'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> copyMessage() async {
    await Clipboard.setData(ClipboardData(text: message));

    const snackBar = SnackBar(content: Text('Message copied'));
    if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSIM Installer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter activation code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _installESim1,
              child: const Text('Install eSIM with Method1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _installESim2,
              child: const Text('Install eSIM with Method2'),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Text(message),
                ),
              ),
              if(message.isNotEmpty)
                ElevatedButton(
                  onPressed: (){
                    copyMessage();
                  },
                  child: const Text('Copy message'),
                )
            ],),
          ],
        ),
      ),
    );
  }
}
