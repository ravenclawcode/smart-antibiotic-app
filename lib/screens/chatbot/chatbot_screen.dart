import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button_send.dart';
import '../../utils/custom_dialog_delete_chat.dart';
import '../../utils/custom_input_chat_form.dart';
import '../../utils/custom_typing_indicator.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;
  bool _isBotTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hai! Saya Sherly. Ada yang bisa aku bantu hari ini?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() => _hasText = _messageController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _hasText = false;
      _isBotTyping = true;
    });

    _messageController.clear();
    Future.delayed(Duration(milliseconds: 50), () => _scrollToBottom());

    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isBotTyping = false;
          _messages.add(
            ChatMessage(
              text:
                  "Terima kasih atas pesannya! Ada hal lain yang ingin ditanyakan?",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        Future.delayed(Duration(milliseconds: 100), () => _scrollToBottom());
      }
    });
  }

  void _deleteChat() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomDialogDeleteChat(),
    );

    if (result == true && mounted) {
      FocusScope.of(context).unfocus();

      setState(() {
        _messages.clear();
        _messages.add(
          ChatMessage(
            text: 'Hai! Saya Sherly. Ada yang bisa aku bantu hari ini?',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(
              context,
              messages: _messages,
              onDeleteTap: _deleteChat,
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildMessagesList(
                messages: _messages,
                scrollController: _scrollController,
                isBotTyping: _isBotTyping,
              ),
            ),
            _buildMessageInput(
              controller: _messageController,
              hasText: _hasText,
              onSendTap: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required List<ChatMessage> messages,
  required VoidCallback onDeleteTap,
}) {
  final bool canDelete = messages.length > 1;
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
            SizedBox(width: 14),
            Text(
              'Asisten Virtual',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: canDelete ? onDeleteTap : null,
              child: Image.asset(
                icDelete,
                height: 20,
                color: canDelete ? AppColors.surfacePrimary : AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMessagesList({
  required List<ChatMessage> messages,
  required ScrollController scrollController,
  required bool isBotTyping,
}) {
  final int typingOffset = isBotTyping ? 1 : 0;

  return ListView.builder(
    controller: scrollController,
    itemCount: messages.length + typingOffset,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemBuilder: (context, index) {
      if (isBotTyping && index == messages.length) {
        return _buildTypingIndicator();
      }

      return _buildMessageBubble(context, messages[index]);
    },
  );
}

Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
  if (message.isUser) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(2.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 18,
                color: AppColors.textWhite,
              ),
            ),
            Text(
              DateFormat('HH.mm').format(message.timestamp),
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: EdgeInsets.only(right: 8),
            child: Image.asset(imgChatbot, fit: BoxFit.contain),
          ),
          // Bubble Pesan
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.68,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.5),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('HH.mm').format(message.timestamp),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMessageInput({
  required TextEditingController controller,
  required bool hasText,
  required VoidCallback onSendTap,
}) {
  return Container(
    padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
    decoration: BoxDecoration(
      color: AppColors.surfacePrimary,
      boxShadow: [
        BoxShadow(
          color: Color(0xFF646464).withValues(alpha: 0.10),
          blurRadius: 10,
          offset: Offset(0, -5),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: CustomInputChatForm(controller: controller)),
        SizedBox(width: 12),
        CustomButtonSend(
          onTap: onSendTap,
          icon: icSend,
          color: hasText ? AppColors.primary : AppColors.secondary,
        ),
      ],
    ),
  );
}

Widget _buildTypingIndicator() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 26,
        height: 26,
        margin: EdgeInsets.only(right: 8),
        child: Image.asset(imgChatbot, fit: BoxFit.contain),
      ),
      CustomTypingIndicator(),
    ],
  );
}
