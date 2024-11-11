package com.alkalab.ourworld

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "agora_chat"
    private val EVENT_CHANNEL = "event"
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initListener" -> {
                    //initListener(result)
                }
                "joinChatRoom" -> {
                    //initListener(result)
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d("fabiola", "LISTENED ON ANDROID!!!")
                    events?.success("SUCCESS")
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }


//    private fun initListener(result: MethodChannel.Result) {
//        ChatClient.getInstance().chatManager().addMessageListener { messages ->
//            for (message in messages) {
//                when (message.type) {
//                    ChatMessage.Type.TXT -> {
//                        val content = (message.body as TextMessageBody).message
//                        result.success("Received a text message from ${message.from}| $content")
//                    }
//                    ChatMessage.Type.IMAGE -> {
//                        result.success("Received an image message from ${message.from}")
//                    }
//                    ChatMessage.Type.VIDEO -> {
//                        result.success("Received a video message from ${message.from}")
//                    }
//                    ChatMessage.Type.LOCATION -> {
//                        result.success("Received a location message from ${message.from}")
//                    }
//                    ChatMessage.Type.FILE -> {
//                        result.success("Received a file message from ${message.from}")
//                    }
//                    ChatMessage.Type.CUSTOM -> {
//                        result.success("Received a custom message from ${message.from}")
//                    }
//                    ChatMessage.Type.CMD -> {
//                        result.success("Received a cmd message from ${message.from}")
//                    }
//                    ChatMessage.Type.VOICE -> {
//                        result.success("Received a voice message from ${message.from}")
//                    }
//                    else -> {
//                        result.error("404", "No message found", null)
//                    }
//                }
//            }
//        }
//    }
}
