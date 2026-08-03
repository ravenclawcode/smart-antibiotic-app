import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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

  bool _isLoading = true;
  bool _hasText = false;
  bool _isBotTyping = false;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() => _hasText = _messageController.text.trim().isNotEmpty);
    });
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Hai! Saya Sherly. Ada yang bisa aku bantu hari ini?",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }
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
        duration: const Duration(milliseconds: 300),
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
    Future.delayed(const Duration(milliseconds: 50), () => _scrollToBottom());

    Timer(const Duration(seconds: 2), () {
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
        Future.delayed(
          const Duration(milliseconds: 100),
          () => _scrollToBottom(),
        );
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
      value: const SystemUiOverlayStyle(
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
              isLoading: _isLoading,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent(context)
                  : _buildMessagesList(
                      messages: _messages,
                      scrollController: _scrollController,
                      isBotTyping: _isBotTyping,
                    ),
            ),
            _buildMessageInput(
              controller: _messageController,
              hasText: _hasText,
              onSendTap: _sendMessage,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppColors.surfacePrimary,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: screenWidth * 0.65,
                height: 90,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2.5),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required List<ChatMessage> messages,
  required VoidCallback onDeleteTap,
  required bool isLoading,
}) {
  final bool canDelete = messages.length > 1;

  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
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
            const SizedBox(width: 14),

            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 180,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Asisten Virtual',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            const Spacer(),

            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              // EFEK ANIMASI PERGANTIAN ICON DELETE
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: InkWell(
                  key: ValueKey<bool>(canDelete),
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: canDelete ? onDeleteTap : null,
                  child: Image.asset(
                    icDelete,
                    height: 20,
                    color: canDelete
                        ? AppColors.surfacePrimary
                        : AppColors.accent,
                  ),
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
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemBuilder: (context, index) {
      if (isBotTyping && index == messages.length) {
        return _buildTypingIndicator();
      }

      // Membungkus pesan dalam AnimatedMessageItem untuk animasi saat baru muncul
      return _AnimatedMessageItem(
        key: ValueKey(messages[index].timestamp),
        child: _buildMessageBubble(context, messages[index]),
      );
    },
  );
}

// Stateful Widget Tambahan untuk Menangani Animasi Teks Baru
class _AnimatedMessageItem extends StatefulWidget {
  final Widget child;

  const _AnimatedMessageItem({super.key, required this.child});

  @override
  State<_AnimatedMessageItem> createState() => _AnimatedMessageItemState();
}

class _AnimatedMessageItemState extends State<_AnimatedMessageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
  if (message.isUser) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
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
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 8),
            child: Image.asset(imgChatbot, fit: BoxFit.contain),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.68,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: const BorderRadius.only(
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
  required bool isLoading,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
    decoration: BoxDecoration(
      color: AppColors.surfacePrimary,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF646464).withValues(alpha: 0.10),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: isLoading
        ? Shimmer.fromColors(
            baseColor: AppColors.surfaceSecondary,
            highlightColor: AppColors.surfaceCool,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 60,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: CustomInputChatForm(controller: controller)),
              const SizedBox(width: 12),
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
        margin: const EdgeInsets.only(right: 8),
        child: Image.asset(imgChatbot, fit: BoxFit.contain),
      ),
      const CustomTypingIndicator(),
    ],
  );
}
